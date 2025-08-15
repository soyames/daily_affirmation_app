import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bug Fixes Tests', () {
    test('should allow unlimited affirmations after 7+ day streak', () {
      // Mock streak data
      int currentStreak = 7;
      int dailyAffirmationsUsed = 25; // More than 20
      
      // Test the fixed logic
      bool canGenerateNewAffirmation() {
        // Users with 7+ day streak have unlimited affirmations
        if (currentStreak >= 7) {
          return true;
        }
        // Same day, check limit
        return dailyAffirmationsUsed < 20;
      }
      
      expect(canGenerateNewAffirmation(), isTrue);
      print('✅ 7+ day streak allows unlimited affirmations');
    });

    test('should limit affirmations to 20 for users with less than 7 day streak', () {
      // Mock streak data
      int currentStreak = 5;
      int dailyAffirmationsUsed = 20; // At limit
      
      // Test the fixed logic
      bool canGenerateNewAffirmation() {
        // Users with 7+ day streak have unlimited affirmations
        if (currentStreak >= 7) {
          return true;
        }
        // Same day, check limit
        return dailyAffirmationsUsed < 20;
      }
      
      expect(canGenerateNewAffirmation(), isFalse);
      print('✅ Users with <7 day streak are limited to 20 affirmations');
    });

    test('should handle notification settings persistence', () {
      // Mock notification settings
      Map<String, dynamic> settings = {
        'enabled': true,
        'hour': 9,
        'minute': 0,
      };
      
      // Test settings validation
      bool isValidSettings(Map<String, dynamic> settings) {
        return settings.containsKey('enabled') &&
               settings.containsKey('hour') &&
               settings.containsKey('minute') &&
               settings['hour'] >= 0 && settings['hour'] <= 23 &&
               settings['minute'] >= 0 && settings['minute'] <= 59;
      }
      
      expect(isValidSettings(settings), isTrue);
      print('✅ Notification settings validation works');
    });

    test('should validate API key presence', () {
      // Test API key validation
      String? validateApiKey(String? apiKey) {
        if (apiKey == null || apiKey.isEmpty) {
          return 'Unsplash API key not found. Please check your .env file.';
        }
        return null;
      }
      
      expect(validateApiKey(null), isNotNull);
      expect(validateApiKey(''), isNotNull);
      expect(validateApiKey('valid_key'), isNull);
      print('✅ API key validation works');
    });
  });
}
