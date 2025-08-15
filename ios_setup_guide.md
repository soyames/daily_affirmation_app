# iOS Build Setup Guide for Daily Affirmations App

## 📱 Current Configuration
- **Bundle ID**: `com.soyames.dailyAffirmation`
- **App Name**: Daily Affirmations
- **Developer**: Yao Amevi A. Sossou (soyames@gmail.com)

## 🍎 Required Steps for iOS Build

### 1. Apple Developer Account
- **Sign up**: https://developer.apple.com/programs/
- **Cost**: $99/year
- **Required for**: App Store distribution

### 2. Certificates & Provisioning
You'll need to create these in Apple Developer Console:

#### Development Certificate:
```bash
# Generate Certificate Signing Request (CSR)
# Use Keychain Access on Mac:
# Keychain Access > Certificate Assistant > Request Certificate from CA
# Email: soyames@gmail.com
# Common Name: Yao Amevi A. Sossou
# Save to disk
```

#### App ID:
- **Bundle ID**: `com.soyames.dailyAffirmation`
- **App Services**: 
  - Push Notifications ✅
  - In-App Purchase (if needed)
  - Associated Domains (for Firebase)

#### Provisioning Profiles:
- **Development Profile**: For testing on devices
- **Distribution Profile**: For App Store submission

### 3. Xcode Configuration
Open `ios/Runner.xcworkspace` in Xcode and:

1. **Select Runner target**
2. **Signing & Capabilities tab**
3. **Team**: Select your Apple Developer Team
4. **Bundle Identifier**: `com.soyames.dailyAffirmation`
5. **Provisioning Profile**: Automatic or Manual

### 4. Firebase iOS Setup
Add your iOS app to Firebase:
1. Go to Firebase Console
2. Add iOS app with bundle ID: `com.soyames.dailyAffirmation`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` folder in Xcode

### 5. Build Commands

#### Debug Build (for testing):
```bash
flutter build ios --debug
```

#### Release Build (for App Store):
```bash
flutter build ios --release
```

#### Archive for App Store:
```bash
# In Xcode:
# Product > Archive
# Then use Organizer to upload to App Store Connect
```

## 🔐 Your PGP Key Usage

Your PGP key (`F199E9AA16FE7F5D9FEACAE22E19729F41E29114`) can be used for:

### Git Commit Signing:
```bash
# Configure Git to use your PGP key
git config --global user.signingkey F199E9AA16FE7F5D9FEACAE22E19729F41E29114
git config --global commit.gpgsign true

# Sign commits
git commit -S -m "Your commit message"
```

### Verify Signed Commits:
```bash
# Verify a commit
git verify-commit HEAD

# Show signature info
git log --show-signature
```

## 📋 iOS Build Checklist

- [ ] Apple Developer Account ($99/year)
- [ ] Development Certificate created
- [ ] Distribution Certificate created  
- [ ] App ID registered (`com.soyames.dailyAffirmation`)
- [ ] Development Provisioning Profile
- [ ] Distribution Provisioning Profile
- [ ] Xcode project configured with Team
- [ ] Firebase iOS app added
- [ ] `GoogleService-Info.plist` added to project
- [ ] Test build on physical device
- [ ] Archive and upload to App Store Connect

## 🚀 Next Steps

1. **Get Apple Developer Account** (if not already)
2. **Create certificates** in Apple Developer Console
3. **Configure Xcode** with your team and certificates
4. **Add Firebase iOS** configuration
5. **Test build** on device
6. **Submit to App Store** when ready

## 📞 Support

If you need help with iOS setup:
- **Apple Developer Support**: https://developer.apple.com/support/
- **Firebase iOS Setup**: https://firebase.google.com/docs/ios/setup
- **Flutter iOS Deployment**: https://docs.flutter.dev/deployment/ios

---

**Note**: Your PGP key is excellent for code signing and verification, but iOS builds require Apple-specific certificates and provisioning profiles.
