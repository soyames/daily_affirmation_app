import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_affirmation/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;

  List<_OnboardingSlide> _getSlides(AppLocalizations loc) => [
        _OnboardingSlide(
          icon: Icons.lightbulb_outline,
          title: loc.onboardingTitle1,
          description: loc.onboardingDesc1,
        ),
        _OnboardingSlide(
          icon: Icons.favorite_outline,
          title: loc.onboardingTitle2,
          description: loc.onboardingDesc2,
        ),
        _OnboardingSlide(
          icon: Icons.emoji_emotions_outlined,
          title: loc.onboardingTitle3,
          description: loc.onboardingDesc3,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final slides = _getSlides(loc);
    final isLast = _currentIndex == slides.length - 1;
    final isFirst = _currentIndex == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(slides[_currentIndex].icon, size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 32),
                    Text(
                      slides[_currentIndex].title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      slides[_currentIndex].description,
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (i) => _buildDot(i == _currentIndex)),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: isFirst ? null : () => setState(() => _currentIndex--),
                ),
                if (isLast)
                  ElevatedButton(
                    onPressed: widget.onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(loc.onboardingStart),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () => setState(() => _currentIndex++),
                  ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool active) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: active ? 14 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: active ? Colors.blueAccent : Colors.white24,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  _OnboardingSlide({required this.icon, required this.title, required this.description});
}
