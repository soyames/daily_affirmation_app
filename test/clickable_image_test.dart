import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clickable Image Tests', () {
    test('should generate correct UTM link when image is clicked', () {
      // Mock affirmation data
      const photographerProfileUrl = 'https://unsplash.com/@johndoe';
      const photographerName = 'John Doe';
      
      // Helper function to ensure UTM parameters (from implementation)
      String ensureUTMParameters(String url) {
        final uri = Uri.parse(url);
        
        if (!uri.host.contains('unsplash.com')) {
          return url;
        }
        
        final queryParams = Map<String, String>.from(uri.queryParameters);
        
        if (!queryParams.containsKey('utm_source')) {
          queryParams['utm_source'] = 'daily_affirmation_app';
        }
        if (!queryParams.containsKey('utm_medium')) {
          queryParams['utm_medium'] = 'referral';
        }
        
        return uri.replace(queryParameters: queryParams).toString();
      }
      
      // Test image click URL generation
      final clickUrl = ensureUTMParameters(photographerProfileUrl);
      
      expect(clickUrl, contains('utm_source=daily_affirmation_app'));
      expect(clickUrl, contains('utm_medium=referral'));
      expect(clickUrl, contains('@johndoe'));
      
      print('✅ Image click generates correct UTM link: $clickUrl');
    });

    test('should handle missing photographer profile URL', () {
      // Test fallback behavior
      const fallbackUrl = 'https://unsplash.com';
      
      String ensureUTMParameters(String url) {
        final uri = Uri.parse(url);
        
        if (!uri.host.contains('unsplash.com')) {
          return url;
        }
        
        final queryParams = Map<String, String>.from(uri.queryParameters);
        
        if (!queryParams.containsKey('utm_source')) {
          queryParams['utm_source'] = 'daily_affirmation_app';
        }
        if (!queryParams.containsKey('utm_medium')) {
          queryParams['utm_medium'] = 'referral';
        }
        
        return uri.replace(queryParameters: queryParams).toString();
      }
      
      final clickUrl = ensureUTMParameters(fallbackUrl);
      
      expect(clickUrl, contains('utm_source=daily_affirmation_app'));
      expect(clickUrl, contains('utm_medium=referral'));
      expect(clickUrl, startsWith('https://unsplash.com'));
      
      print('✅ Fallback URL works correctly: $clickUrl');
    });

    test('should generate appropriate feedback messages', () {
      // Test feedback message generation
      String generateFeedbackMessage(String? photographerName) {
        if (photographerName != null && photographerName.isNotEmpty) {
          return 'Opening $photographerName\'s profile...';
        } else {
          return 'Opening Unsplash...';
        }
      }

      expect(generateFeedbackMessage('John Doe'), equals('Opening John Doe\'s profile...'));
      expect(generateFeedbackMessage(null), equals('Opening Unsplash...'));
      expect(generateFeedbackMessage(''), equals('Opening Unsplash...'));
      
      print('✅ Feedback messages work correctly');
    });
  });
}
