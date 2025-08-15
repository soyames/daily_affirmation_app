import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  static FirebaseAnalyticsObserver get observer => _observer;

  /// Initialize analytics and track app launch
  static Future<void> initialize() async {
    try {
      // Set user properties
      await _analytics.setUserProperty(
        name: 'platform',
        value: kIsWeb ? 'web' : 'mobile',
      );

      // Track app launch
      await logEvent('app_launch', parameters: {
        'platform': kIsWeb ? 'web' : 'mobile',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('✅ Analytics initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Analytics initialization failed: $e');
      }
    }
  }

  /// Track when user accesses the app via Firebase hosting
  static Future<void> trackWebAccess() async {
    if (!kIsWeb) return;

    try {
      await logEvent('web_access', parameters: {
        'access_method': 'firebase_hosting',
        'timestamp': DateTime.now().toIso8601String(),
        'user_agent': 'web_browser',
      });

      if (kDebugMode) {
        print('✅ Web access tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Web access tracking failed: $e');
      }
    }
  }

  /// Track when user adds app to home screen (PWA install)
  static Future<void> trackPWAInstall() async {
    try {
      await logEvent('pwa_install', parameters: {
        'install_method': 'add_to_home_screen',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('✅ PWA install tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ PWA install tracking failed: $e');
      }
    }
  }

  /// Track notification permission granted
  static Future<void> trackNotificationPermission(bool granted) async {
    try {
      await logEvent('notification_permission', parameters: {
        'permission_granted': granted,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('✅ Notification permission tracked: $granted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Notification permission tracking failed: $e');
      }
    }
  }

  /// Track affirmation views
  static Future<void> trackAffirmationView(int affirmationIndex) async {
    try {
      await logEvent('affirmation_view', parameters: {
        'affirmation_index': affirmationIndex,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Affirmation view tracking failed: $e');
      }
    }
  }

  /// Track affirmation sharing
  static Future<void> trackAffirmationShare(int affirmationIndex, String shareMethod) async {
    try {
      await logEvent('affirmation_share', parameters: {
        'affirmation_index': affirmationIndex,
        'share_method': shareMethod,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Affirmation share tracking failed: $e');
      }
    }
  }

  /// Track favorites actions
  static Future<void> trackFavoriteAction(int affirmationIndex, bool isFavorited) async {
    try {
      await logEvent('favorite_action', parameters: {
        'affirmation_index': affirmationIndex,
        'action': isFavorited ? 'add' : 'remove',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favorite action tracking failed: $e');
      }
    }
  }

  /// Track photographer profile clicks
  static Future<void> trackPhotographerClick(String? photographerName) async {
    try {
      await logEvent('photographer_click', parameters: {
        'photographer_name': photographerName ?? 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Photographer click tracking failed: $e');
      }
    }
  }

  /// Generic event logging
  static Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Event logging failed for $name: $e');
      }
    }
  }

  /// Set user ID for tracking
  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Set user ID failed: $e');
      }
    }
  }

  /// Track screen views
  static Future<void> trackScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Screen view tracking failed: $e');
      }
    }
  }
}
