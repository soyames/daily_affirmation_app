import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UTM Parameter Tests', () {
    test('should add UTM parameters to Unsplash URLs', () {
      // Test the UTM parameter addition logic
      String addUTMParameters(String url) {
        final uri = Uri.parse(url);
        final queryParams = Map<String, String>.from(uri.queryParameters);
        
        // Add UTM parameters as required by Unsplash API guidelines
        queryParams['utm_source'] = 'daily_affirmation_app';
        queryParams['utm_medium'] = 'referral';
        
        return uri.replace(queryParameters: queryParams).toString();
      }

      // Test cases
      const testUrl1 = 'https://unsplash.com/@photographer';
      const testUrl2 = 'https://unsplash.com/@photographer?existing=param';
      
      final result1 = addUTMParameters(testUrl1);
      final result2 = addUTMParameters(testUrl2);
      
      // Verify UTM parameters are added
      expect(result1, contains('utm_source=daily_affirmation_app'));
      expect(result1, contains('utm_medium=referral'));
      expect(result2, contains('utm_source=daily_affirmation_app'));
      expect(result2, contains('utm_medium=referral'));
      expect(result2, contains('existing=param'));
      
      print('Test URL 1 result: $result1');
      print('Test URL 2 result: $result2');
    });

    test('should ensure UTM parameters for existing URLs', () {
      String ensureUTMParameters(String url) {
        final uri = Uri.parse(url);
        
        // Only add UTM parameters to Unsplash URLs
        if (!uri.host.contains('unsplash.com')) {
          return url;
        }
        
        final queryParams = Map<String, String>.from(uri.queryParameters);
        
        // Add UTM parameters if they don't exist
        if (!queryParams.containsKey('utm_source')) {
          queryParams['utm_source'] = 'daily_affirmation_app';
        }
        if (!queryParams.containsKey('utm_medium')) {
          queryParams['utm_medium'] = 'referral';
        }
        
        return uri.replace(queryParameters: queryParams).toString();
      }

      // Test cases
      const urlWithoutUTM = 'https://unsplash.com/@photographer';
      const urlWithUTM = 'https://unsplash.com/@photographer?utm_source=daily_affirmation_app&utm_medium=referral';
      const nonUnsplashUrl = 'https://example.com/page';
      
      final result1 = ensureUTMParameters(urlWithoutUTM);
      final result2 = ensureUTMParameters(urlWithUTM);
      final result3 = ensureUTMParameters(nonUnsplashUrl);
      
      // Verify results
      expect(result1, contains('utm_source=daily_affirmation_app'));
      expect(result1, contains('utm_medium=referral'));
      expect(result2, contains('utm_source=daily_affirmation_app'));
      expect(result2, contains('utm_medium=referral'));
      expect(result3, equals(nonUnsplashUrl)); // Non-Unsplash URLs should remain unchanged
      
      print('URL without UTM result: $result1');
      print('URL with UTM result: $result2');
      print('Non-Unsplash URL result: $result3');
    });
  });
}
