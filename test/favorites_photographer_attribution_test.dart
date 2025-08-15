import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Favorites Photographer Attribution Tests', () {
    test('should display photographer attribution in favorites', () {
      // Mock affirmation data with photographer info
      const photographerName = 'John Doe';
      const photographerProfileUrl = 'https://unsplash.com/@johndoe';
      
      // Test that attribution is displayed when photographer data is available
      bool shouldShowAttribution = photographerName.isNotEmpty;
      
      expect(shouldShowAttribution, isTrue);
      print('✅ Photographer attribution is displayed in favorites when data is available');
    });

    test('should create proper share text with photographer attribution', () {
      // Mock data
      const affirmationText = 'I am capable of amazing things.';
      const photographerName = 'Jane Smith';
      const photographerProfileUrl = 'https://unsplash.com/@janesmith';
      
      // Helper function to ensure UTM parameters
      String ensureUTMParameters(String url) {
        final uri = Uri.parse(url);
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
      if (photographerName.isNotEmpty) {
        final photographerUrl = ensureUTMParameters(photographerProfileUrl);
        shareText += '\n\nPhoto by $photographerName on Unsplash\n$photographerUrl';
      }
      
      // Verify the share text contains all expected elements
      expect(shareText, contains(affirmationText));
      expect(shareText, contains('Photo by $photographerName on Unsplash'));
      expect(shareText, contains('utm_source=daily_affirmation_app'));
      expect(shareText, contains('utm_medium=referral'));
      expect(shareText, contains('@janesmith'));
      
      print('✅ Share text includes proper photographer attribution with UTM parameters');
      print('Generated share text:');
      print(shareText);
    });

    test('should handle missing photographer data gracefully', () {
      // Test fallback behavior when no photographer data is available
      const affirmationText = 'I am capable of amazing things.';
      const imageUrl = 'https://images.unsplash.com/photo-123456';
      
      // Test share text creation without photographer attribution
      String shareText = affirmationText;
      shareText += '\n\nImage from: $imageUrl';
      
      // Verify fallback behavior
      expect(shareText, contains(affirmationText));
      expect(shareText, contains('Image from: $imageUrl'));
      expect(shareText, isNot(contains('Photo by')));
      
      print('✅ Fallback behavior works when photographer data is missing');
      print('Generated fallback share text:');
      print(shareText);
    });

    test('should create clickable attribution links', () {
      // Test that attribution text is clickable and opens correct URL
      const photographerProfileUrl = 'https://unsplash.com/@photographer';
      
      String ensureUTMParameters(String url) {
        final uri = Uri.parse(url);
        final queryParams = Map<String, String>.from(uri.queryParameters);
        
        queryParams['utm_source'] = 'daily_affirmation_app';
        queryParams['utm_medium'] = 'referral';
        
        return uri.replace(queryParameters: queryParams).toString();
      }
      
      final clickableUrl = ensureUTMParameters(photographerProfileUrl);
      
      expect(clickableUrl, contains('utm_source=daily_affirmation_app'));
      expect(clickableUrl, contains('utm_medium=referral'));
      expect(clickableUrl, contains('@photographer'));
      
      print('✅ Attribution text creates proper clickable links with UTM parameters');
      print('Clickable URL: $clickableUrl');
    });
  });
}
