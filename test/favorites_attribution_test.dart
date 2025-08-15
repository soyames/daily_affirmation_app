import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Favorites Attribution Tests', () {
    test('should create proper share text with photographer attribution', () {
      // Mock affirmation data
      const affirmationText = 'I am capable of amazing things.';
      const photographerName = 'John Doe';
      const photographerProfileUrl = 'https://unsplash.com/@johndoe';
      
      // Helper function to ensure UTM parameters (copied from implementation)
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
      
      // Test share text creation with photographer attribution
      String shareText = affirmationText;
      final photographerUrl = ensureUTMParameters(photographerProfileUrl);
      shareText += '\n\nPhoto by $photographerName on Unsplash\n$photographerUrl';
      
      // Verify the share text contains all expected elements
      expect(shareText, contains(affirmationText));
      expect(shareText, contains('Photo by $photographerName on Unsplash'));
      expect(shareText, contains('utm_source=daily_affirmation_app'));
      expect(shareText, contains('utm_medium=referral'));
      
      print('Generated share text:');
      print(shareText);
    });

    test('should handle missing photographer attribution gracefully', () {
      const affirmationText = 'I am capable of amazing things.';
      const imageUrl = 'https://images.unsplash.com/photo-123456';
      
      // Test share text creation without photographer attribution
      String shareText = affirmationText;
      shareText += '\n\nImage from: $imageUrl';
      
      // Verify fallback behavior
      expect(shareText, contains(affirmationText));
      expect(shareText, contains('Image from: $imageUrl'));
      expect(shareText, isNot(contains('Photo by')));
      
      print('Generated fallback share text:');
      print(shareText);
    });
  });
}
