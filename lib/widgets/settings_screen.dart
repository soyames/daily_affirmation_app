// lib/widgets/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_affirmation/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:flutter/foundation.dart';
import '../providers/notification_provider.dart';
import '../providers/offline_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    final offlineCache = ref.watch(offlineCacheProvider);
    final offlineCacheNotifier = ref.read(offlineCacheProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 20),
              
              // Notifications Section
              _buildSectionHeader('Notifications', Icons.notifications),
              const SizedBox(height: 16),
              
              _buildNotificationToggle(
                context,
                notificationSettings,
                notificationNotifier,
              ),
              
              if (notificationSettings.enabled) ...[
                const SizedBox(height: 16),
                _buildTimeSelector(
                  context,
                  notificationSettings,
                  notificationNotifier,
                ),
                const SizedBox(height: 16),
                _buildTestNotificationButton(context),
              ],
              
              const SizedBox(height: 32),

              // Offline Mode Section
              _buildSectionHeader('Offline Mode', Icons.cloud_off),
              const SizedBox(height: 16),

              _buildOfflineModeToggle(
                context,
                offlineCache,
                offlineCacheNotifier,
              ),

              if (offlineCache.cachedAffirmations.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildCacheInfo(offlineCache, offlineCacheNotifier),
              ],

              const SizedBox(height: 32),

              // App Information Section
              _buildSectionHeader('About', Icons.info),
              const SizedBox(height: 16),
              
              _buildInfoTile(
                'Version',
                '1.2.0',
                Icons.code,
              ),

              _buildInfoTile(
                'Total Affirmations',
                '106',
                Icons.format_quote,
              ),

              _buildInfoTile(
                'Languages Supported',
                '6',
                Icons.language,
              ),

              const SizedBox(height: 16),

              // Developer Information
              _buildDeveloperTile(),
              
              const SizedBox(height: 32),
              
              // Support Section
              _buildSectionHeader('Support', Icons.help),
              const SizedBox(height: 16),
              
              _buildActionTile(
                'Rate the App',
                'Help us improve by rating the app',
                Icons.star,
                () => _rateApp(context),
              ),

              _buildActionTile(
                'Send Feedback',
                'Share your thoughts and suggestions',
                Icons.feedback,
                () => _sendFeedback(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineModeToggle(
    BuildContext context,
    OfflineCache cache,
    OfflineCacheNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            cache.isOfflineMode ? Icons.cloud_off : Icons.cloud,
            color: cache.isOfflineMode ? Colors.orange : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Offline Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cache.isOfflineMode
                    ? 'Using cached affirmations only'
                    : 'Download new affirmations from internet',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: cache.isOfflineMode,
            onChanged: (_) => notifier.toggleOfflineMode(),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildCacheInfo(OfflineCache cache, OfflineCacheNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.storage, color: Colors.white70, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cache Storage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notifier.cacheStatusMessage,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () => _showClearCacheDialog(context, notifier),
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: notifier.cacheUsagePercentage / 100,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              notifier.cacheUsagePercentage > 80 ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context,
    NotificationSettings settings,
    NotificationSettingsNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            settings.enabled ? Icons.notifications_active : Icons.notifications_off,
            color: settings.enabled ? Colors.green : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Reminders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  settings.enabled 
                    ? 'Get reminded to read your daily affirmation'
                    : 'Enable notifications to get daily reminders',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: settings.enabled,
            onChanged: (value) async {
              // Show immediate feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? 'Enabling notifications...' : 'Disabling notifications...'),
                  duration: const Duration(seconds: 1),
                ),
              );

              try {
                await notifier.toggleNotifications();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value ? 'Notifications enabled!' : 'Notifications disabled!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update notifications: $e'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.blue, size: 28),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Send a test notification now',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _sendTestNotification(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    NotificationSettings settings,
    NotificationSettingsNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white70, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reminder Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${settings.hour.toString().padLeft(2, '0')}:${settings.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _selectTime(context, settings, notifier),
            child: const Text(
              'Change',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        tileColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    NotificationSettings settings,
    NotificationSettingsNotifier notifier,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              surface: Color(0xFF1a1a2e),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await notifier.updateSettings(
        hour: picked.hour,
        minute: picked.minute,
      );
    }
  }

  Widget _buildDeveloperTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blue[300],
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Developer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Yao Amevi A. Sossou',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchLinkedIn(),
            child: Row(
              children: [
                Icon(
                  Icons.link,
                  color: Colors.blue[300],
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'LinkedIn Profile',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchLinkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/in/ameviy/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch LinkedIn profile';
      }
    } catch (e) {
      // Handle error silently or show a message
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    try {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        // Show the in-app review dialog
        await inAppReview.requestReview();

        if (kDebugMode) {
          print('✅ In-app review dialog shown');
        }
      } else {
        // Fallback to opening the store
        await inAppReview.openStoreListing(
          appStoreId: 'your-app-store-id', // Replace with actual App Store ID
        );

        if (kDebugMode) {
          print('✅ Opened store listing for rating');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error showing app rating: $e');
      }

      // Show error dialog
      if (context.mounted) {
        _showErrorDialog(context, 'Unable to open app rating. Please try again later.');
      }
    }
  }

  Future<void> _sendFeedback(BuildContext context) async {
    try {
      final mailtoLink = Mailto(
        to: ['soyames@gmail.com'], // Your email address
        subject: 'Daily Affirmations App - Feedback',
        body: '''
Hi Yao,

I'm using the Daily Affirmations app and wanted to share some feedback:

App Version: 1.2.0
Device: ${kIsWeb ? 'Web Browser' : 'Mobile Device'}

My feedback:
[Please write your feedback here]

Best regards,
A Daily Affirmations User
        ''',
      );

      await launchUrl(Uri.parse('$mailtoLink'));

      if (kDebugMode) {
        print('✅ Feedback email opened');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error opening feedback email: $e');
      }

      // Fallback: Show feedback dialog with copy option
      if (context.mounted) {
        _showFeedbackDialog(context);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Send Feedback',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share your thoughts and suggestions:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type your feedback here...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Or email us directly at: soyames@gmail.com',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Copy feedback to clipboard and show success message
              final feedback = feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                // In a real app, you might want to copy to clipboard or send via another method
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback! Please email it to soyames@gmail.com'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }



  void _showClearCacheDialog(BuildContext context, OfflineCacheNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Clear Cache?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will remove all cached affirmations. You\'ll need an internet connection to load new ones.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearCache();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendTestNotification(BuildContext context) async {
    try {
      // Import the notification service
      await NotificationService.initialize();

      // Request permissions
      final hasPermission = await NotificationService.requestPermissions();
      if (!hasPermission) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Send immediate test notification
      await NotificationService.sendImmediateNotification(
        title: 'Test Notification 🌟',
        body: 'Your notifications are working perfectly!',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
