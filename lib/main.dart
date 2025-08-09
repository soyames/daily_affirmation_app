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
import 'ad_helper.dart';
import 'widgets/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (!kIsWeb) {
    MobileAds.instance.initialize();
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

    const bool isMobile = !kIsWeb;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
          Positioned(
            bottom: isMobile ? 190 : 60, // Repositioned the button higher
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  affirmationNotifier.getNewAffirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(localizations.newAffirmation),
              ),
            ),
          ),
        ],
      ),
    );
  }
}