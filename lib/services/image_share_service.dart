import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/affirmation_provider.dart';

class ImageShareService {

  /// Shares an affirmation with enhanced text including attribution
  static Future<void> shareAffirmationAsImage({
    required Affirmation affirmation,
    required String affirmationText,
    required BuildContext context,
  }) async {
    // For now, share enhanced text with attribution
    // TODO: Implement image generation and sharing in future update

    String shareText = '✨ $affirmationText ✨';
    shareText += '\n\n📱 Shared from Daily Affirmations app';

    if (affirmation.photographerName != null && affirmation.photographerName!.isNotEmpty) {
      final photographerUrl = _ensureUTMParameters(
        affirmation.photographerProfileUrl ?? 'https://unsplash.com'
      );
      shareText += '\n\n📸 Photo by ${affirmation.photographerName} on Unsplash';
      shareText += '\n🔗 $photographerUrl';
    }

    shareText += '\n\n🌟 Get your daily dose of positivity!';

    await Share.share(shareText);
  }

  /// Ensures UTM parameters are added to Unsplash URLs
  static String _ensureUTMParameters(String url) {
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
}
