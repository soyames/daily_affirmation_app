import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  group('App Icon Configuration Tests', () {
    test('should verify custom app icon exists', () {
      // Check if the custom icon file exists
      final iconFile = File('assets/app_icon/icon.png');
      
      expect(iconFile.existsSync(), isTrue);
      print('✅ Custom app icon file exists at: ${iconFile.path}');
    });

    test('should verify Android launcher icons are generated', () {
      // Check Android icon directories
      final androidIconDirs = [
        'android/app/src/main/res/mipmap-hdpi',
        'android/app/src/main/res/mipmap-mdpi',
        'android/app/src/main/res/mipmap-xhdpi',
        'android/app/src/main/res/mipmap-xxhdpi',
        'android/app/src/main/res/mipmap-xxxhdpi',
      ];

      for (final dir in androidIconDirs) {
        final launcherIcon = File('$dir/launcher_icon.png');
        expect(launcherIcon.existsSync(), isTrue);
        print('✅ Android launcher icon exists: $dir/launcher_icon.png');
      }
    });

    test('should verify iOS app icons are generated', () {
      // Check iOS icon directory
      final iosIconDir = Directory('ios/Runner/Assets.xcassets/AppIcon.appiconset');
      
      expect(iosIconDir.existsSync(), isTrue);
      
      // Check for some key iOS icon files
      final iosIcons = [
        'Icon-App-1024x1024@1x.png',
        'Icon-App-60x60@2x.png',
        'Icon-App-60x60@3x.png',
        'Contents.json',
      ];

      for (final iconName in iosIcons) {
        final iconFile = File('${iosIconDir.path}/$iconName');
        expect(iconFile.existsSync(), isTrue);
        print('✅ iOS app icon exists: $iconName');
      }
    });

    test('should verify web icons are generated', () {
      // Check web icon directory
      final webIcons = [
        'web/icons/Icon-192.png',
        'web/icons/Icon-512.png',
        'web/icons/Icon-maskable-192.png',
        'web/icons/Icon-maskable-512.png',
      ];

      for (final iconPath in webIcons) {
        final iconFile = File(iconPath);
        expect(iconFile.existsSync(), isTrue);
        print('✅ Web icon exists: $iconPath');
      }
    });

    test('should verify Android manifest uses custom icon', () {
      // Check Android manifest configuration
      final manifestFile = File('android/app/src/main/AndroidManifest.xml');
      
      expect(manifestFile.existsSync(), isTrue);
      
      final manifestContent = manifestFile.readAsStringSync();
      expect(manifestContent.contains('android:icon="@mipmap/launcher_icon"'), isTrue);
      
      print('✅ Android manifest correctly configured to use custom launcher_icon');
    });

    test('should verify web manifest uses custom icons', () {
      // Check web manifest configuration
      final manifestFile = File('web/manifest.json');
      
      expect(manifestFile.existsSync(), isTrue);
      
      final manifestContent = manifestFile.readAsStringSync();
      expect(manifestContent.contains('icons/Icon-192.png'), isTrue);
      expect(manifestContent.contains('icons/Icon-512.png'), isTrue);
      expect(manifestContent.contains('icons/Icon-maskable-192.png'), isTrue);
      expect(manifestContent.contains('icons/Icon-maskable-512.png'), isTrue);
      
      print('✅ Web manifest correctly configured to use custom icons');
    });

    test('should verify pubspec.yaml icon configuration', () {
      // Check pubspec.yaml configuration
      final pubspecFile = File('pubspec.yaml');
      
      expect(pubspecFile.existsSync(), isTrue);
      
      final pubspecContent = pubspecFile.readAsStringSync();
      expect(pubspecContent.contains('flutter_launcher_icons:'), isTrue);
      expect(pubspecContent.contains('image_path: "assets/app_icon/icon.png"'), isTrue);
      expect(pubspecContent.contains('android: "launcher_icon"'), isTrue);
      expect(pubspecContent.contains('ios: true'), isTrue);
      
      print('✅ pubspec.yaml correctly configured for custom app icon');
    });

    test('should verify icon file is not empty', () {
      // Check that the icon file has content (not corrupted)
      final iconFile = File('assets/app_icon/icon.png');
      
      expect(iconFile.existsSync(), isTrue);
      
      final fileSize = iconFile.lengthSync();
      expect(fileSize, greaterThan(1000)); // Should be at least 1KB for a valid PNG
      
      print('✅ Custom app icon file has valid size: $fileSize bytes');
    });
  });
}
