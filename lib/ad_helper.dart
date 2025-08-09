// lib/ad_helper.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Helper function to get the correct ad unit ID for the platform.
String get adUnitId {
  // This check is safe because this code is only called on mobile
  if (Platform.isAndroid) {
    return 'ca-app-pub-8032708206790621~1294853414';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-8032708206790621/6595313371';
  }
  return '';
}

// A widget to display the banner ad.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded) {
      return SizedBox(
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd),
      );
    } else {
      return const SizedBox.shrink(); // Hide the ad space if it's not loaded.
    }
  }
}