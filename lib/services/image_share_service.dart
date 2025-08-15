import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../providers/affirmation_provider.dart';

class ImageShareService {

  /// Shares an affirmation as an actual image with text overlay and attribution
  static Future<void> shareAffirmationAsImage({
    required Affirmation affirmation,
    required String affirmationText,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create the image with text overlay
      final imageFile = await _createAffirmationImage(
        affirmation: affirmation,
        affirmationText: affirmationText,
      );

      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (imageFile != null) {
        // Share the actual image file
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: '✨ Daily Affirmation ✨\n\n📱 Shared from Daily Affirmations app',
        );
      } else {
        // Fallback to text sharing if image creation fails
        await _shareAsText(affirmation, affirmationText);
      }
    } catch (e) {
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
    try {
      // Download the background image
      final backgroundImage = await _downloadImage(affirmation.imageUrl);
      if (backgroundImage == null) return null;

      // Create the composite image with text overlay
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Image dimensions
      const double imageWidth = 1080;
      const double imageHeight = 1080;

      // Draw background image
      canvas.drawImageRect(
        backgroundImage,
        Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
        const Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        Paint(),
      );

      // Add dark overlay for better text readability
      final overlayPaint = Paint()
        ..color = Colors.black.withOpacity(0.4);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        overlayPaint,
      );

      // Draw affirmation text
      await _drawText(
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
        await _drawText(
          canvas: canvas,
          text: 'Photo by ${affirmation.photographerName} on Unsplash',
          x: 60,
          y: imageHeight - 120,
          fontSize: 24,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.normal,
          maxWidth: imageWidth - 120,
          textAlign: TextAlign.left,
        );
      }

      // Draw app branding
      await _drawText(
        canvas: canvas,
        text: 'Daily Affirmations App',
        x: imageWidth - 60,
        y: imageHeight - 60,
        fontSize: 20,
        color: Colors.white.withOpacity(0.7),
        fontWeight: FontWeight.normal,
        maxWidth: 300,
        textAlign: TextAlign.right,
      );

      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(imageWidth.toInt(), imageHeight.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/affirmation_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      return file;
    } catch (e) {
      print('Error creating affirmation image: $e');
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
  static Future<void> _drawText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required double maxWidth,
    required TextAlign textAlign,
  }) async {
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
