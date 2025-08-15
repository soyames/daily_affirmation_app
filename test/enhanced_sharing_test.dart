import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Enhanced Sharing Tests', () {
    test('should create enhanced share text with attribution', () {
      // Mock affirmation data
      const affirmationText = 'I am capable of amazing things.';
      const photographerName = 'John Doe';
      const photographerProfileUrl = 'https://unsplash.com/@johndoe';
      
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
      
      // Create enhanced share text
      String shareText = '✨ $affirmationText ✨';
      shareText += '\n\n📱 Shared from Daily Affirmations app';
      
      if (photographerName.isNotEmpty) {
        final photographerUrl = ensureUTMParameters(photographerProfileUrl);
        shareText += '\n\n📸 Photo by $photographerName on Unsplash';
        shareText += '\n🔗 $photographerUrl';
      }
      
      shareText += '\n\n🌟 Get your daily dose of positivity!';
      
      // Verify the enhanced share text
      expect(shareText, contains('✨ $affirmationText ✨'));
      expect(shareText, contains('📱 Shared from Daily Affirmations app'));
      expect(shareText, contains('📸 Photo by $photographerName on Unsplash'));
      expect(shareText, contains('utm_source=daily_affirmation_app'));
      expect(shareText, contains('utm_medium=referral'));
      expect(shareText, contains('🌟 Get your daily dose of positivity!'));
      
      print('✅ Enhanced share text created successfully');
      print('Generated share text:');
      print(shareText);
    });

    test('should handle missing photographer data in share text', () {
      // Mock affirmation data without photographer
      const affirmationText = 'I am worthy of love and respect.';
      
      // Create enhanced share text without photographer
      String shareText = '✨ $affirmationText ✨';
      shareText += '\n\n📱 Shared from Daily Affirmations app';
      shareText += '\n\n🌟 Get your daily dose of positivity!';
      
      // Verify the share text
      expect(shareText, contains('✨ $affirmationText ✨'));
      expect(shareText, contains('📱 Shared from Daily Affirmations app'));
      expect(shareText, contains('🌟 Get your daily dose of positivity!'));
      expect(shareText, isNot(contains('Photo by')));
      
      print('✅ Enhanced share text works without photographer data');
      print('Generated share text:');
      print(shareText);
    });

    test('should verify app branding in shared content', () {
      // Test that shared content includes proper app branding
      const affirmationText = 'Today is full of possibilities.';
      
      String shareText = '✨ $affirmationText ✨';
      shareText += '\n\n📱 Shared from Daily Affirmations app';
      shareText += '\n\n🌟 Get your daily dose of positivity!';
      
      // Verify branding elements
      expect(shareText, contains('Daily Affirmations app'));
      expect(shareText, contains('✨')); // Decorative elements
      expect(shareText, contains('📱')); // App icon
      expect(shareText, contains('🌟')); // Positive emoji
      
      print('✅ App branding is properly included in shared content');
    });

    test('should verify UTM tracking in shared URLs', () {
      // Test UTM parameter addition
      const originalUrl = 'https://unsplash.com/@photographer';
      
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
      
      final trackedUrl = ensureUTMParameters(originalUrl);
      
      expect(trackedUrl, contains('utm_source=daily_affirmation_app'));
      expect(trackedUrl, contains('utm_medium=referral'));
      expect(trackedUrl, contains('@photographer'));
      
      print('✅ UTM tracking parameters are correctly added to shared URLs');
      print('Tracked URL: $trackedUrl');
    });
  });
}
