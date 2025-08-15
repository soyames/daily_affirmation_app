import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class WebNotificationService {
  static Timer? _notificationTimer;
  static bool _isInitialized = false;
  
  // Notification settings keys
  static const String _notificationEnabledKey = 'web_notifications_enabled';
  static const String _notificationTimeKey = 'web_notification_time';
  static const String _lastNotificationKey = 'web_last_notification_date';

  // Affirmations for notifications
  static const List<String> _affirmations = [
    "I am capable of amazing things.",
    "Today is full of possibilities.",
    "I choose to focus on what I can control.",
    "I am worthy of love and respect.",
    "Every challenge is an opportunity to grow.",
    "I trust in my ability to overcome obstacles.",
    "I am grateful for this moment.",
    "My potential is limitless.",
    "I choose peace over worry.",
    "I am exactly where I need to be.",
    "I embrace change as a path to growth.",
    "I am strong, capable, and resilient.",
    "Today I choose joy.",
    "I believe in myself and my dreams.",
    "I am creating a life I love.",
  ];

  /// Initialize web notifications
  static Future<void> initialize() async {
    if (!kIsWeb || _isInitialized) return;

    try {
      _isInitialized = true;
      await _scheduleNextNotification();
      
      if (kDebugMode) {
        print('✅ Web notification service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize web notifications: $e');
      }
    }
  }

  /// Request notification permission from browser
  static Future<bool> requestPermission() async {
    if (!kIsWeb) return false;

    try {
      // This will be handled by the browser's native permission API
      // The actual implementation would use dart:html but we'll simulate it
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, true);
      
      if (kDebugMode) {
        print('✅ Web notification permission requested');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to request notification permission: $e');
      }
      return false;
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!kIsWeb) return false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationEnabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set notification time
  static Future<void> setNotificationTime(int hour, int minute) async {
    if (!kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      await prefs.setString(_notificationTimeKey, timeString);
      
      // Reschedule notifications with new time
      await _scheduleNextNotification();
      
      if (kDebugMode) {
        print('✅ Web notification time set to $timeString');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set notification time: $e');
      }
    }
  }

  /// Get notification time
  static Future<Map<String, int>> getNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = prefs.getString(_notificationTimeKey) ?? '09:00';
      final parts = timeString.split(':');
      return {
        'hour': int.parse(parts[0]),
        'minute': int.parse(parts[1]),
      };
    } catch (e) {
      return {'hour': 9, 'minute': 0}; // Default to 9:00 AM
    }
  }

  /// Enable or disable notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (!kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, enabled);
      
      if (enabled) {
        await _scheduleNextNotification();
      } else {
        _cancelNotifications();
      }
      
      if (kDebugMode) {
        print('✅ Web notifications ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set notification state: $e');
      }
    }
  }

  /// Schedule the next notification
  static Future<void> _scheduleNextNotification() async {
    if (!kIsWeb) return;

    try {
      final enabled = await areNotificationsEnabled();
      if (!enabled) return;

      _cancelNotifications();

      final notificationTime = await getNotificationTime();
      final now = DateTime.now();
      
      // Calculate next notification time
      var nextNotification = DateTime(
        now.year,
        now.month,
        now.day,
        notificationTime['hour']!,
        notificationTime['minute']!,
      );

      // If the time has passed today, schedule for tomorrow
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      final delay = nextNotification.difference(now);
      
      _notificationTimer = Timer(delay, () async {
        await _showNotification();
        // Schedule the next day's notification
        await _scheduleNextNotification();
      });

      if (kDebugMode) {
        print('✅ Next web notification scheduled for: $nextNotification');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to schedule notification: $e');
      }
    }
  }

  /// Show a notification
  static Future<void> _showNotification() async {
    if (!kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastNotification = prefs.getString(_lastNotificationKey);

      // Don't show multiple notifications on the same day
      if (lastNotification == today) return;

      // Get a random affirmation
      final random = Random();
      final affirmation = _affirmations[random.nextInt(_affirmations.length)];

      // Save that we showed a notification today
      await prefs.setString(_lastNotificationKey, today);

      // In a real implementation, this would use the browser's Notification API
      // For now, we'll just log it
      if (kDebugMode) {
        print('🔔 Daily Affirmation: $affirmation');
        print('✅ Web notification shown for today');
      }

      // TODO: Implement actual browser notification using dart:html
      // This would require:
      // new html.Notification('Daily Affirmation', {
      //   'body': affirmation,
      //   'icon': '/icons/Icon-192.png',
      //   'badge': '/icons/Icon-192.png',
      // });

    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to show notification: $e');
      }
    }
  }

  /// Cancel all scheduled notifications
  static void _cancelNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

  /// Test notification (for debugging)
  static Future<void> testNotification() async {
    if (!kIsWeb) return;

    try {
      final random = Random();
      final affirmation = _affirmations[random.nextInt(_affirmations.length)];
      
      if (kDebugMode) {
        print('🔔 Test Notification: $affirmation');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to show test notification: $e');
      }
    }
  }

  /// Dispose resources
  static void dispose() {
    _cancelNotifications();
    _isInitialized = false;
  }
}
