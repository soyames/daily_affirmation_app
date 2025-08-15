// lib/widgets/affirmation_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:daily_affirmation/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/affirmation_provider.dart';
import '../services/image_share_service.dart';

class AffirmationCard extends ConsumerWidget {
  final Affirmation affirmation;

  const AffirmationCard({super.key, required this.affirmation});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Ensures UTM parameters are added to Unsplash URLs for proper attribution
  String _ensureUTMParameters(String url) {
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

  // A helper method to get the correct localized affirmation string
  String _getAffirmationText(BuildContext context, int index) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    switch (index) {
      case 1:
        return localizations.affirmation_1;
      case 2:
        return localizations.affirmation_2;
      case 3:
        return localizations.affirmation_3;
      case 4:
        return localizations.affirmation_4;
      case 5:
        return localizations.affirmation_5;
      case 6:
        return localizations.affirmation_6;
      case 7:
        return localizations.affirmation_7;
      case 8:
        return localizations.affirmation_8;
      case 9:
        return localizations.affirmation_9;
      case 10:
        return localizations.affirmation_10;
      case 11:
        return localizations.affirmation_11;
      case 12:
        return localizations.affirmation_12;
      case 13:
        return localizations.affirmation_13;
      case 14:
        return localizations.affirmation_14;
      case 15:
        return localizations.affirmation_15;
      case 16:
        return localizations.affirmation_16;
      case 17:
        return localizations.affirmation_17;
      case 18:
        return localizations.affirmation_18;
      case 19:
        return localizations.affirmation_19;
      case 20:
        return localizations.affirmation_20;
      case 21:
        return localizations.affirmation_21;
      case 22:
        return localizations.affirmation_22;
      case 23:
        return localizations.affirmation_23;
      case 24:
        return localizations.affirmation_24;
      case 25:
        return localizations.affirmation_25;
      case 26:
        return localizations.affirmation_26;
      case 27:
        return localizations.affirmation_27;
      case 28:
        return localizations.affirmation_28;
      case 29:
        return localizations.affirmation_29;
      case 30:
        return localizations.affirmation_30;
      case 31:
        return localizations.affirmation_31;
      case 32:
        return localizations.affirmation_32;
      case 33:
        return localizations.affirmation_33;
      case 34:
        return localizations.affirmation_34;
      case 35:
        return localizations.affirmation_35;
      case 36:
        return localizations.affirmation_36;
      case 37:
        return localizations.affirmation_37;
      case 38:
        return localizations.affirmation_38;
      case 39:
        return localizations.affirmation_39;
      case 40:
        return localizations.affirmation_40;
      case 41:
        return localizations.affirmation_41;
      case 42:
        return localizations.affirmation_42;
      case 43:
        return localizations.affirmation_43;
      case 44:
        return localizations.affirmation_44;
      case 45:
        return localizations.affirmation_45;
      case 46:
        return localizations.affirmation_46;
      case 47:
        return localizations.affirmation_47;
      case 48:
        return localizations.affirmation_48;
      case 49:
        return localizations.affirmation_49;
      case 50:
        return localizations.affirmation_50;
      case 51:
        return localizations.affirmation_51;
      case 52:
        return localizations.affirmation_52;
      case 53:
        return localizations.affirmation_53;
      case 54:
        return localizations.affirmation_54;
      case 55:
        return localizations.affirmation_55;
      case 56:
        return localizations.affirmation_56;
      case 57:
        return localizations.affirmation_57;
      case 58:
        return localizations.affirmation_58;
      case 59:
        return localizations.affirmation_59;
      case 60:
        return localizations.affirmation_60;
      case 61:
        return localizations.affirmation_61;
      case 62:
        return localizations.affirmation_62;
      case 63:
        return localizations.affirmation_63;
      case 64:
        return localizations.affirmation_64;
      case 65:
        return localizations.affirmation_65;
      case 66:
        return localizations.affirmation_66;
      case 67:
        return localizations.affirmation_67;
      case 68:
        return localizations.affirmation_68;
      case 69:
        return localizations.affirmation_69;
      case 70:
        return localizations.affirmation_70;
      case 71:
        return localizations.affirmation_71;
      case 72:
        return localizations.affirmation_72;
      case 73:
        return localizations.affirmation_73;
      case 74:
        return localizations.affirmation_74;
      case 75:
        return localizations.affirmation_75;
      case 76:
        return localizations.affirmation_76;
      case 77:
        return localizations.affirmation_77;
      case 78:
        return localizations.affirmation_78;
      case 79:
        return localizations.affirmation_79;
      case 80:
        return localizations.affirmation_80;
      case 81:
        return localizations.affirmation_81;
      case 82:
        return localizations.affirmation_82;
      case 83:
        return localizations.affirmation_83;
      case 84:
        return localizations.affirmation_84;
      case 85:
        return localizations.affirmation_85;
      case 86:
        return localizations.affirmation_86;
      case 87:
        return localizations.affirmation_87;
      case 88:
        return localizations.affirmation_88;
      case 89:
        return localizations.affirmation_89;
      case 90:
        return localizations.affirmation_90;
      case 91:
        return localizations.affirmation_91;
      case 92:
        return localizations.affirmation_92;
      case 93:
        return localizations.affirmation_93;
      case 94:
        return localizations.affirmation_94;
      case 95:
        return localizations.affirmation_95;
      case 96:
        return localizations.affirmation_96;
      case 97:
        return localizations.affirmation_97;
      case 98:
        return localizations.affirmation_98;
      case 99:
        return localizations.affirmation_99;
      case 100:
        return localizations.affirmation_100;
      case 101:
        return localizations.affirmation_101;
      case 102:
        return localizations.affirmation_102;
      case 103:
        return localizations.affirmation_103;
      case 104:
        return localizations.affirmation_104;
      case 105:
        return localizations.affirmation_105;
      case 106:
        return localizations.affirmation_106;
      default:
        return "Unknown affirmation";
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String affirmationText = _getAffirmationText(context, affirmation.affirmationIndex);

    return GestureDetector(
      onTap: () {
        final url = affirmation.photographerProfileUrl ?? 'https://unsplash.com';
        _launchUrl(_ensureUTMParameters(url));
      },
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: affirmation.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          // Dark overlay for text readability
          Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          // Subtle clickable indicator
          if (affirmation.photographerName != null)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white70,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new,
                      color: Colors.white70,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          // Affirmation Text
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              affirmationText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Photo Attribution Text
        if (affirmation.photographerName != null)
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                final url = affirmation.photographerProfileUrl ?? 'https://unsplash.com';
                _launchUrl(_ensureUTMParameters(url));
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  children: [
                    const TextSpan(text: 'Photo by '),
                    TextSpan(
                      text: affirmation.photographerName,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' on '),
                    const TextSpan(
                      text: 'Unsplash',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Share button
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 20),
                onPressed: () async {
                  final affirmationText = _getAffirmationText(context, affirmation.affirmationIndex);

                  await ImageShareService.shareAffirmationAsImage(
                    affirmation: affirmation,
                    affirmationText: affirmationText,
                    context: context,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}