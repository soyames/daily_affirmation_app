// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Localization imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:daily_affirmation/l10n/app_localizations.dart';

// Import custom widgets and services
import 'widgets/affirmation_card.dart';
import 'providers/affirmation_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/streak_provider.dart';
import 'ad_helper.dart';
import 'widgets/favorites_screen.dart';
import 'widgets/settings_screen.dart';
import 'widgets/streak_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  if (!kIsWeb) {
    MobileAds.instance.initialize();
    await NotificationService.initialize();
  }

  runApp(const ProviderScope(child: DailyAffirmationApp()));
}

class DailyAffirmationApp extends StatelessWidget {
  const DailyAffirmationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Affirmation',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // navigatorObservers: [
      //   AnalyticsService.observer,
      // ],
      home: const AffirmationScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('ar'), // Arabic
        Locale('zh'), // Chinese
      ],
    );
  }
}

class AffirmationScreen extends ConsumerWidget {
  const AffirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final affirmationState = ref.watch(affirmationProvider);
    final affirmationNotifier = ref.read(affirmationProvider.notifier);

    // Record visit for streak tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(streakProvider.notifier).recordVisit();
      _checkNotificationPrompt(context, ref);
    });

    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;
    final isSmallScreen = screenSize.width < 360;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Responsive positioning
    final streakTopPosition = isSmallScreen ? 90.0 : isMobile ? 100.0 : isTablet ? 120.0 : 140.0;
    final buttonBottomPosition = isSmallScreen ? 100.0 : isMobile ? 120.0 : 60.0;

    final bool isFavorited = affirmationState.value?.isFavorited ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 10,
        actions: [
          // Favorite button (to save/unsave current affirmation)
          IconButton(
            icon: Icon(
              isFavorited ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              color: isFavorited ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              if (affirmationState.hasValue) {
                ref.read(favoritesProvider.notifier).toggleFavorite(affirmationState.value!.currentAffirmation);
              }
            },
          ),
          const SizedBox(width: 16), // Increased horizontal spacing
          // Button to navigate to the favorites screen
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),
          // Settings button with notification indicator
          Consumer(
            builder: (context, ref, child) {
              final notificationSettings = ref.watch(notificationSettingsProvider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    },
                  ),
                  if (!notificationSettings.enabled)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          affirmationState.when(
            data: (state) => AffirmationCard(affirmation: state.currentAffirmation),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                localizations.errorText(err.toString()),
              ),
            ),
          ),
          if (isMobile)
            const Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: AdBanner(),
              ),
            ),
          // Streak widget on the left side below app name
          Positioned(
            top: streakTopPosition,
            left: 0,
            child: const StreakWidget(),
          ),



          Positioned(
            bottom: buttonBottomPosition, // Responsive button positioning
            left: 0,
            right: 0,
            child: Center(
              child: Consumer(
                builder: (context, ref, child) {
                  final streakNotifier = ref.read(streakProvider.notifier);
                  final canGenerate = streakNotifier.canGenerateNewAffirmation();

                  return ElevatedButton(
                    onPressed: canGenerate ? () {
                      // Force refresh and get new affirmation
                      affirmationNotifier.forceRefresh();
                    } : () {
                      _showDailyLimitDialog(context, ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canGenerate ? Colors.white : Colors.grey,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(localizations.newAffirmation),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDailyLimitDialog(BuildContext context, WidgetRef ref) {
    final streakData = ref.read(streakProvider);
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilTomorrow = tomorrow.difference(now);
    final hours = timeUntilTomorrow.inHours;
    final minutes = timeUntilTomorrow.inMinutes % 60;

    // Responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;

    final titleFontSize = isSmallScreen ? 20.0 : isTablet ? 28.0 : 24.0;
    final bodyFontSize = isSmallScreen ? 14.0 : isTablet ? 18.0 : 16.0;
    final padding = isSmallScreen ? 16.0 : isTablet ? 32.0 : 24.0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.9),
                  Colors.red.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '⏰',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  'Daily Limit Reached!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'You\'ve used all 20 affirmations for today.\nCome back tomorrow for more inspiration!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: bodyFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Next reset in:',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hours}h ${minutes}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (streakData.currentStreak < 5) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '💡 Pro Tip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build a 5-day streak to unlock unlimited affirmations!\nCurrent streak: ${streakData.currentStreak} days',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Got it!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkNotificationPrompt(BuildContext context, WidgetRef ref) async {
    final notificationSettings = ref.read(notificationSettingsProvider);
    final promptNotifier = ref.read(notificationPromptProvider.notifier);
    final streakData = ref.read(streakProvider);

    // Show prompt if:
    // 1. Notifications are not enabled
    // 2. User hasn't been prompted before
    // 3. User has used the app at least 2 times (has some streak data)
    if (!notificationSettings.enabled &&
        !promptNotifier.hasBeenShown &&
        streakData.totalDays >= 2) {

      // Wait a bit before showing the prompt
      await Future.delayed(const Duration(seconds: 3));
      if (context.mounted) {
        _showNotificationPrompt(context, ref);
        promptNotifier.markPromptShown();
      }
    }
  }

  void _showNotificationPrompt(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e),
          title: const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Daily Reminders',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Text(
            'Would you like to receive daily reminders to read your affirmations? You can customize the time in settings.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Maybe Later',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsScreen())
                );
              },
              child: const Text(
                'Set Up Notifications',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }
}