import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../providers/affirmation_provider.dart';

class ImageShareService {

  /// Shares an affirmation as an actual image with text overlay and attribution
  static Future<void> shareAffirmationAsImage({
    required Affirmation affirmation,
    required String affirmationText,
    required BuildContext context,
  }) async {
    if (kIsWeb) {
      // On web, image creation is complex and often fails
      // Use enhanced text sharing with better formatting
      await _shareEnhancedText(affirmation, affirmationText, context);
      return;
    }

    try {
      // Show loading indicator for mobile
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: Color(0xFF1a1a2e),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Creating image...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );

      print('🖼️ Starting image creation for: $affirmationText');

      // Create the image with text overlay (mobile only)
      final imageFile = await _createAffirmationImage(
        affirmation: affirmation,
        affirmationText: affirmationText,
      );

      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (imageFile != null) {
        print('✅ Image created successfully: ${imageFile.path}');
        // Share the actual image file
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: '✨ Daily Affirmation ✨\n\n📱 Shared from Daily Affirmations app',
        );
        print('✅ Image shared successfully');
      } else {
        print('❌ Image creation failed, falling back to text');
        // Fallback to text sharing if image creation fails
        await _shareAsText(affirmation, affirmationText);
      }
    } catch (e) {
      print('❌ Error in shareAffirmationAsImage: $e');
      // Hide loading indicator if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Fallback to text sharing
      await _shareAsText(affirmation, affirmationText);
    }
  }

  /// Creates an image with affirmation text overlay and photographer attribution
  static Future<File?> _createAffirmationImage({
    required Affirmation affirmation,
    required String affirmationText,
  }) async {
    if (kIsWeb) {
      print('❌ Image creation not supported on web platform');
      return null;
    }

    try {
      print('🔄 Downloading background image...');
      // Download the background image
      final backgroundImage = await _downloadImage(affirmation.imageUrl);
      if (backgroundImage == null) {
        print('❌ Failed to download background image');
        return null;
      }
      print('✅ Background image downloaded');

      // Create the composite image with text overlay
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Image dimensions
      const double imageWidth = 1080;
      const double imageHeight = 1080;

      print('🎨 Drawing background image...');
      // Draw background image
      canvas.drawImageRect(
        backgroundImage,
        Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
        const Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        Paint(),
      );

      // Add dark overlay for better text readability
      final overlayPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.4);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        overlayPaint,
      );

      print('✍️ Drawing affirmation text...');
      // Draw affirmation text
      _drawText(
        canvas: canvas,
        text: affirmationText,
        x: imageWidth / 2,
        y: imageHeight / 2 - 100,
        fontSize: 48,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        maxWidth: imageWidth - 120,
        textAlign: TextAlign.center,
      );

      // Draw photographer attribution
      if (affirmation.photographerName != null && affirmation.photographerName!.isNotEmpty) {
        print('📸 Drawing photographer attribution...');
        _drawText(
          canvas: canvas,
          text: 'Photo by ${affirmation.photographerName} on Unsplash',
          x: 60,
          y: imageHeight - 120,
          fontSize: 24,
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.normal,
          maxWidth: imageWidth - 120,
          textAlign: TextAlign.left,
        );
      }

      // Draw app branding
      print('🏷️ Drawing app branding...');
      _drawText(
        canvas: canvas,
        text: 'Daily Affirmations App',
        x: imageWidth - 60,
        y: imageHeight - 60,
        fontSize: 20,
        color: Colors.white.withValues(alpha: 0.7),
        fontWeight: FontWeight.normal,
        maxWidth: 300,
        textAlign: TextAlign.right,
      );

      print('🖼️ Converting to image...');
      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(imageWidth.toInt(), imageHeight.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        print('❌ Failed to convert to byte data');
        return null;
      }

      print('💾 Saving to file...');
      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/affirmation_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      print('✅ Image file created: ${file.path}');
      return file;
    } catch (e, stackTrace) {
      print('❌ Error creating affirmation image: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Downloads an image from URL and returns as ui.Image
  static Future<ui.Image?> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        return frame.image;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }

  /// Draws text on canvas with specified parameters
  static void _drawText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required double maxWidth,
    required TextAlign textAlign,
  }) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'Roboto',
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    textPainter.layout(maxWidth: maxWidth);

    // Calculate position based on text alignment
    double drawX = x;
    if (textAlign == TextAlign.center) {
      drawX = x - (textPainter.width / 2);
    } else if (textAlign == TextAlign.right) {
      drawX = x - textPainter.width;
    }

    textPainter.paint(canvas, Offset(drawX, y - (textPainter.height / 2)));
  }

  /// Enhanced text sharing for web with better visual formatting
  static Future<void> _shareEnhancedText(Affirmation affirmation, String affirmationText, BuildContext context) async {
    // Show a nice dialog with the affirmation and copy option
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          '✨ Share Affirmation',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ $affirmationText ✨',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '📱 Shared from Daily Affirmations app',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (affirmation.photographerName != null && affirmation.photographerName!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '📸 Photo by ${affirmation.photographerName} on Unsplash',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    '🌟 Get your daily dose of positivity!',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Copy the text above and share it manually, or use the share button below.',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _shareAsText(affirmation, affirmationText);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Share Text'),
          ),
        ],
      ),
    );
  }

  /// Fallback method to share as text when image creation fails
  static Future<void> _shareAsText(Affirmation affirmation, String affirmationText) async {
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
