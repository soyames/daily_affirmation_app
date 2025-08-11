// lib/providers/notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Notification settings
  static const String _notificationEnabledKey = 'notifications_enabled';
  static const String _notificationTimeKey = 'notification_time';
  static const int _notificationId = 0;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific screen
    // TODO: Add navigation logic here if needed
  }

  static Future<bool> requestPermissions() async {
    try {
      // For Android 13+ (API level 33+), we need to request notification permission
      if (Platform.isAndroid) {
        final androidInfo = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        if (androidInfo != null) {
          final granted = await androidInfo.requestNotificationsPermission();
          if (granted != null && granted) {
            return true;
          }
        }

        // Fallback to permission_handler
        final status = await Permission.notification.request();
        return status == PermissionStatus.granted;
      }

      // For iOS, request permission through the notification plugin
      if (Platform.isIOS) {
        final iosInfo = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        if (iosInfo != null) {
          final granted = await iosInfo.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        }
      }

      return true;
    } catch (e) {
      // Fallback: try to schedule notification anyway
      return true;
    }
  }

  static Future<void> scheduleDaily({
    required int hour,
    required int minute,
    bool enabled = true,
  }) async {
    try {
      // Cancel all existing notifications first
      await _notifications.cancelAll();

      if (!enabled) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_notificationEnabledKey, false);
        return;
      }

      // Save settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, enabled);
      await prefs.setString(_notificationTimeKey, '$hour:$minute');

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

      // If the scheduled time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

    const androidDetails = AndroidNotificationDetails(
      'daily_affirmation',
      'Daily Affirmations',
      channelDescription: 'Daily positive affirmation reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      _notificationId,
      'Daily Affirmation 🌟',
      _getRandomNotificationMessage(),
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    } catch (e) {
      // If scheduling fails, still save the settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, enabled);
      await prefs.setString(_notificationTimeKey, '$hour:$minute');
      rethrow;
    }
  }

  static String _getRandomNotificationMessage() {
    final messages = [
      'Start your day with positivity! ✨',
      'Your daily dose of inspiration awaits 🌅',
      'Time for your positive affirmation 💫',
      'Brighten your day with beautiful words 🌸',
      'Your moment of mindfulness is here 🧘‍♀️',
      'Ready for some daily motivation? 🚀',
      'Let\'s make today amazing together! 🌟',
      'Your daily inspiration is waiting 🌺',
    ];
    return messages[Random().nextInt(messages.length)];
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? false;
  }

  static Future<String> getScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notificationTimeKey) ?? '9:00';
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, false);
  }

  static Future<void> sendImmediateNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications for debugging',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // Test notification ID
      title,
      body,
      notificationDetails,
    );
  }
}

// Notification settings state
class NotificationSettings {
  final bool enabled;
  final int hour;
  final int minute;

  NotificationSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  NotificationSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

// Notification settings notifier
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(NotificationSettings(enabled: false, hour: 9, minute: 0)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await NotificationService.isEnabled();
    final timeString = await NotificationService.getScheduledTime();
    final timeParts = timeString.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 9;
    final minute = int.tryParse(timeParts[1]) ?? 0;

    state = NotificationSettings(enabled: enabled, hour: hour, minute: minute);
  }

  Future<void> updateSettings({
    bool? enabled,
    int? hour,
    int? minute,
  }) async {
    try {
      final newSettings = state.copyWith(
        enabled: enabled,
        hour: hour,
        minute: minute,
      );

      if (newSettings.enabled) {
        // Initialize notifications first
        await NotificationService.initialize();

        // Request permissions
        final hasPermission = await NotificationService.requestPermissions();
        if (!hasPermission) {
          // If permission denied, keep notifications disabled
          state = newSettings.copyWith(enabled: false);
          return;
        }
      }

      // Schedule or cancel notifications
      await NotificationService.scheduleDaily(
        hour: newSettings.hour,
        minute: newSettings.minute,
        enabled: newSettings.enabled,
      );

      // Update state only after successful scheduling
      state = newSettings;
    } catch (e) {
      // If anything fails, revert to disabled state
      state = state.copyWith(enabled: false);
      rethrow;
    }
  }

  Future<void> toggleNotifications() async {
    try {
      await updateSettings(enabled: !state.enabled);
    } catch (e) {
      // If toggle fails, revert state
      state = state.copyWith(enabled: state.enabled);
    }
  }
}

// Provider
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});
