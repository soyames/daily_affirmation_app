import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/pwa_service.dart';

class PWAInstallButton extends StatefulWidget {
  const PWAInstallButton({super.key});

  @override
  State<PWAInstallButton> createState() => _PWAInstallButtonState();
}

class _PWAInstallButtonState extends State<PWAInstallButton> {
  bool _isInstallPromptAvailable = false;
  bool _isInstallingPWA = false;

  @override
  void initState() {
    super.initState();
    _checkInstallPromptAvailability();
  }

  void _checkInstallPromptAvailability() {
    if (kIsWeb) {
      setState(() {
        _isInstallPromptAvailable = PWAService.isInstallPromptAvailable;
      });
    }
  }

  Future<void> _installPWA() async {
    if (!kIsWeb || _isInstallingPWA) return;

    setState(() {
      _isInstallingPWA = true;
    });

    try {
      final success = await PWAService.showInstallPrompt();
      
      if (success) {
        // Hide the button after successful installation
        setState(() {
          _isInstallPromptAvailable = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ App installed successfully! You can now access it from your home screen.'),
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to install app. Please try again.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInstallingPWA = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show on web and when install prompt is available
    if (!kIsWeb || !_isInstallPromptAvailable || PWAService.isRunningAsPWA) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.get_app,
                size: 32,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              const Text(
                'Install App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add Daily Affirmations to your home screen for quick access and offline use.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isInstallingPWA ? null : _installPWA,
                  icon: _isInstallingPWA
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(_isInstallingPWA ? 'Installing...' : 'Install Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isInstallPromptAvailable = false;
                  });
                },
                child: const Text(
                  'Maybe later',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PWAStatusIndicator extends StatelessWidget {
  const PWAStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final isRunningAsPWA = PWAService.isRunningAsPWA;
    final displayMode = PWAService.displayMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRunningAsPWA ? Colors.green.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRunningAsPWA ? Icons.smartphone : Icons.web,
            size: 14,
            color: isRunningAsPWA ? Colors.green : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            isRunningAsPWA ? 'PWA' : 'Web',
            style: TextStyle(
              fontSize: 12,
              color: isRunningAsPWA ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
