import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Affirmation'**
  String get appTitle;

  /// No description provided for @newAffirmation.
  ///
  /// In en, this message translates to:
  /// **'New Affirmation'**
  String get newAffirmation;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorText(Object error);

  /// No description provided for @affirmation_1.
  ///
  /// In en, this message translates to:
  /// **'You are capable of amazing things.'**
  String get affirmation_1;

  /// No description provided for @affirmation_2.
  ///
  /// In en, this message translates to:
  /// **'Believe in yourself and your abilities.'**
  String get affirmation_2;

  /// No description provided for @affirmation_3.
  ///
  /// In en, this message translates to:
  /// **'Today is a new day filled with possibilities.'**
  String get affirmation_3;

  /// No description provided for @affirmation_4.
  ///
  /// In en, this message translates to:
  /// **'Your potential is limitless.'**
  String get affirmation_4;

  /// No description provided for @affirmation_5.
  ///
  /// In en, this message translates to:
  /// **'Embrace the journey, trust the process.'**
  String get affirmation_5;

  /// No description provided for @affirmation_6.
  ///
  /// In en, this message translates to:
  /// **'I am the architect of my life; I build its foundations and choose its contents.'**
  String get affirmation_6;

  /// No description provided for @affirmation_7.
  ///
  /// In en, this message translates to:
  /// **'My mind is filled with positive thoughts.'**
  String get affirmation_7;

  /// No description provided for @affirmation_8.
  ///
  /// In en, this message translates to:
  /// **'I am filled with confidence and self-esteem.'**
  String get affirmation_8;

  /// No description provided for @affirmation_9.
  ///
  /// In en, this message translates to:
  /// **'Every day is a new opportunity to grow and learn.'**
  String get affirmation_9;

  /// No description provided for @affirmation_10.
  ///
  /// In en, this message translates to:
  /// **'I attract success and prosperity into my life.'**
  String get affirmation_10;

  /// No description provided for @affirmation_11.
  ///
  /// In en, this message translates to:
  /// **'I am worthy of love, happiness, and success.'**
  String get affirmation_11;

  /// No description provided for @affirmation_12.
  ///
  /// In en, this message translates to:
  /// **'My body is a temple, and I treat it with respect.'**
  String get affirmation_12;

  /// No description provided for @affirmation_13.
  ///
  /// In en, this message translates to:
  /// **'I am at peace with all that has happened, is happening, and will happen.'**
  String get affirmation_13;

  /// No description provided for @affirmation_14.
  ///
  /// In en, this message translates to:
  /// **'I release all negative thoughts and feelings.'**
  String get affirmation_14;

  /// No description provided for @affirmation_15.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for all the good in my life.'**
  String get affirmation_15;

  /// No description provided for @affirmation_16.
  ///
  /// In en, this message translates to:
  /// **'I have the power to create the life I desire.'**
  String get affirmation_16;

  /// No description provided for @affirmation_17.
  ///
  /// In en, this message translates to:
  /// **'Challenges are opportunities for me to grow.'**
  String get affirmation_17;

  /// No description provided for @affirmation_18.
  ///
  /// In en, this message translates to:
  /// **'I am surrounded by people who love and support me.'**
  String get affirmation_18;

  /// No description provided for @affirmation_19.
  ///
  /// In en, this message translates to:
  /// **'My dreams are within reach, and I am working to achieve them.'**
  String get affirmation_19;

  /// No description provided for @affirmation_20.
  ///
  /// In en, this message translates to:
  /// **'I am confident in my own skin.'**
  String get affirmation_20;

  /// No description provided for @affirmation_21.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for positive experiences.'**
  String get affirmation_21;

  /// No description provided for @affirmation_22.
  ///
  /// In en, this message translates to:
  /// **'I trust my intuition and inner guidance.'**
  String get affirmation_22;

  /// No description provided for @affirmation_23.
  ///
  /// In en, this message translates to:
  /// **'I am a source of inspiration for others.'**
  String get affirmation_23;

  /// No description provided for @affirmation_24.
  ///
  /// In en, this message translates to:
  /// **'I am patient and persistent in my pursuits.'**
  String get affirmation_24;

  /// No description provided for @affirmation_25.
  ///
  /// In en, this message translates to:
  /// **'My life is a reflection of my positive mindset.'**
  String get affirmation_25;

  /// No description provided for @affirmation_26.
  ///
  /// In en, this message translates to:
  /// **'I am surrounded by abundance.'**
  String get affirmation_26;

  /// No description provided for @affirmation_27.
  ///
  /// In en, this message translates to:
  /// **'I am creating my own future, one step at a time.'**
  String get affirmation_27;

  /// No description provided for @affirmation_28.
  ///
  /// In en, this message translates to:
  /// **'I am in complete control of my emotions.'**
  String get affirmation_28;

  /// No description provided for @affirmation_29.
  ///
  /// In en, this message translates to:
  /// **'I am constantly evolving and becoming a better version of myself.'**
  String get affirmation_29;

  /// No description provided for @affirmation_30.
  ///
  /// In en, this message translates to:
  /// **'I am creative and full of brilliant ideas.'**
  String get affirmation_30;

  /// No description provided for @affirmation_31.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful creator of my reality.'**
  String get affirmation_31;

  /// No description provided for @affirmation_32.
  ///
  /// In en, this message translates to:
  /// **'I am confident and courageous.'**
  String get affirmation_32;

  /// No description provided for @affirmation_33.
  ///
  /// In en, this message translates to:
  /// **'My thoughts create my reality, so I choose positive ones.'**
  String get affirmation_33;

  /// No description provided for @affirmation_34.
  ///
  /// In en, this message translates to:
  /// **'I am a master of my own destiny.'**
  String get affirmation_34;

  /// No description provided for @affirmation_35.
  ///
  /// In en, this message translates to:
  /// **'I choose joy and happiness every single day.'**
  String get affirmation_35;

  /// No description provided for @affirmation_36.
  ///
  /// In en, this message translates to:
  /// **'My future is bright and full of potential.'**
  String get affirmation_36;

  /// No description provided for @affirmation_37.
  ///
  /// In en, this message translates to:
  /// **'I am a positive influence on those around me.'**
  String get affirmation_37;

  /// No description provided for @affirmation_38.
  ///
  /// In en, this message translates to:
  /// **'I am a beautiful and unique individual.'**
  String get affirmation_38;

  /// No description provided for @affirmation_39.
  ///
  /// In en, this message translates to:
  /// **'I am resilient and can overcome any obstacle.'**
  String get affirmation_39;

  /// No description provided for @affirmation_40.
  ///
  /// In en, this message translates to:
  /// **'I am worthy of all the good things that happen to me.'**
  String get affirmation_40;

  /// No description provided for @affirmation_41.
  ///
  /// In en, this message translates to:
  /// **'I am full of energy and vitality.'**
  String get affirmation_41;

  /// No description provided for @affirmation_42.
  ///
  /// In en, this message translates to:
  /// **'I am a compassionate and kind person.'**
  String get affirmation_42;

  /// No description provided for @affirmation_43.
  ///
  /// In en, this message translates to:
  /// **'I am thankful for my life and all its blessings.'**
  String get affirmation_43;

  /// No description provided for @affirmation_44.
  ///
  /// In en, this message translates to:
  /// **'I am making a positive impact on the world.'**
  String get affirmation_44;

  /// No description provided for @affirmation_45.
  ///
  /// In en, this message translates to:
  /// **'I am a lifelong learner, always seeking knowledge.'**
  String get affirmation_45;

  /// No description provided for @affirmation_46.
  ///
  /// In en, this message translates to:
  /// **'I am a force of nature, unstoppable and powerful.'**
  String get affirmation_46;

  /// No description provided for @affirmation_47.
  ///
  /// In en, this message translates to:
  /// **'I am proud of all my accomplishments.'**
  String get affirmation_47;

  /// No description provided for @affirmation_48.
  ///
  /// In en, this message translates to:
  /// **'I am a beacon of light and positivity.'**
  String get affirmation_48;

  /// No description provided for @affirmation_49.
  ///
  /// In en, this message translates to:
  /// **'I am in charge of my own happiness.'**
  String get affirmation_49;

  /// No description provided for @affirmation_50.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful, capable, and resourceful human being.'**
  String get affirmation_50;

  /// No description provided for @affirmation_51.
  ///
  /// In en, this message translates to:
  /// **'I forgive myself and others for past mistakes.'**
  String get affirmation_51;

  /// No description provided for @affirmation_52.
  ///
  /// In en, this message translates to:
  /// **'I radiate love and attract love in return.'**
  String get affirmation_52;

  /// No description provided for @affirmation_53.
  ///
  /// In en, this message translates to:
  /// **'I am open to new opportunities and experiences.'**
  String get affirmation_53;

  /// No description provided for @affirmation_54.
  ///
  /// In en, this message translates to:
  /// **'I am committed to my personal growth.'**
  String get affirmation_54;

  /// No description provided for @affirmation_55.
  ///
  /// In en, this message translates to:
  /// **'I am enough, just as I am.'**
  String get affirmation_55;

  /// No description provided for @affirmation_56.
  ///
  /// In en, this message translates to:
  /// **'I choose peace over perfection.'**
  String get affirmation_56;

  /// No description provided for @affirmation_57.
  ///
  /// In en, this message translates to:
  /// **'I am a strong and courageous woman/man.'**
  String get affirmation_57;

  /// No description provided for @affirmation_58.
  ///
  /// In en, this message translates to:
  /// **'I am building a life I love.'**
  String get affirmation_58;

  /// No description provided for @affirmation_59.
  ///
  /// In en, this message translates to:
  /// **'I trust the timing of my life.'**
  String get affirmation_59;

  /// No description provided for @affirmation_60.
  ///
  /// In en, this message translates to:
  /// **'I am a wonderful and unique soul.'**
  String get affirmation_60;

  /// No description provided for @affirmation_61.
  ///
  /// In en, this message translates to:
  /// **'I am a source of strength and comfort for my loved ones.'**
  String get affirmation_61;

  /// No description provided for @affirmation_62.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my health and well-being.'**
  String get affirmation_62;

  /// No description provided for @affirmation_63.
  ///
  /// In en, this message translates to:
  /// **'I am deserving of respect and admiration.'**
  String get affirmation_63;

  /// No description provided for @affirmation_64.
  ///
  /// In en, this message translates to:
  /// **'I am fearless in the pursuit of what sets my soul on fire.'**
  String get affirmation_64;

  /// No description provided for @affirmation_65.
  ///
  /// In en, this message translates to:
  /// **'I am a kind, loving, and generous person.'**
  String get affirmation_65;

  /// No description provided for @affirmation_66.
  ///
  /// In en, this message translates to:
  /// **'I am constantly learning and improving.'**
  String get affirmation_66;

  /// No description provided for @affirmation_67.
  ///
  /// In en, this message translates to:
  /// **'I am a loving and devoted friend/partner/family member.'**
  String get affirmation_67;

  /// No description provided for @affirmation_68.
  ///
  /// In en, this message translates to:
  /// **'I am living my best life.'**
  String get affirmation_68;

  /// No description provided for @affirmation_69.
  ///
  /// In en, this message translates to:
  /// **'I am confident and unafraid to be myself.'**
  String get affirmation_69;

  /// No description provided for @affirmation_70.
  ///
  /// In en, this message translates to:
  /// **'I am capable of achieving anything I set my mind to.'**
  String get affirmation_70;

  /// No description provided for @affirmation_71.
  ///
  /// In en, this message translates to:
  /// **'I am powerful beyond measure.'**
  String get affirmation_71;

  /// No description provided for @affirmation_72.
  ///
  /// In en, this message translates to:
  /// **'I am at peace with my past.'**
  String get affirmation_72;

  /// No description provided for @affirmation_73.
  ///
  /// In en, this message translates to:
  /// **'I am excited about my future.'**
  String get affirmation_73;

  /// No description provided for @affirmation_74.
  ///
  /// In en, this message translates to:
  /// **'I am a masterpiece in progress.'**
  String get affirmation_74;

  /// No description provided for @affirmation_75.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful co-creator of my destiny.'**
  String get affirmation_75;

  /// No description provided for @affirmation_76.
  ///
  /// In en, this message translates to:
  /// **'I am blessed with an abundance of blessings.'**
  String get affirmation_76;

  /// No description provided for @affirmation_77.
  ///
  /// In en, this message translates to:
  /// **'I am a beautiful, strong, and capable person.'**
  String get affirmation_77;

  /// No description provided for @affirmation_78.
  ///
  /// In en, this message translates to:
  /// **'I am a warrior, not a worrier.'**
  String get affirmation_78;

  /// No description provided for @affirmation_79.
  ///
  /// In en, this message translates to:
  /// **'I am a great listener and a wonderful friend.'**
  String get affirmation_79;

  /// No description provided for @affirmation_80.
  ///
  /// In en, this message translates to:
  /// **'I am in a constant state of growth and evolution.'**
  String get affirmation_80;

  /// No description provided for @affirmation_81.
  ///
  /// In en, this message translates to:
  /// **'I am surrounded by love and kindness.'**
  String get affirmation_81;

  /// No description provided for @affirmation_82.
  ///
  /// In en, this message translates to:
  /// **'I am a beautiful and strong individual.'**
  String get affirmation_82;

  /// No description provided for @affirmation_83.
  ///
  /// In en, this message translates to:
  /// **'I am a positive force in the world.'**
  String get affirmation_83;

  /// No description provided for @affirmation_84.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for success.'**
  String get affirmation_84;

  /// No description provided for @affirmation_85.
  ///
  /// In en, this message translates to:
  /// **'I am a creator, not a reactor.'**
  String get affirmation_85;

  /// No description provided for @affirmation_86.
  ///
  /// In en, this message translates to:
  /// **'I am fearless and free.'**
  String get affirmation_86;

  /// No description provided for @affirmation_87.
  ///
  /// In en, this message translates to:
  /// **'I am a unique and amazing person.'**
  String get affirmation_87;

  /// No description provided for @affirmation_88.
  ///
  /// In en, this message translates to:
  /// **'I am a gift to the world.'**
  String get affirmation_88;

  /// No description provided for @affirmation_89.
  ///
  /// In en, this message translates to:
  /// **'I am a light, shining brightly.'**
  String get affirmation_89;

  /// No description provided for @affirmation_90.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful and influential person.'**
  String get affirmation_90;

  /// No description provided for @affirmation_91.
  ///
  /// In en, this message translates to:
  /// **'I am a kind and compassionate soul.'**
  String get affirmation_91;

  /// No description provided for @affirmation_92.
  ///
  /// In en, this message translates to:
  /// **'I am a great leader and a great follower.'**
  String get affirmation_92;

  /// No description provided for @affirmation_93.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful and influential leader.'**
  String get affirmation_93;

  /// No description provided for @affirmation_94.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for opportunities.'**
  String get affirmation_94;

  /// No description provided for @affirmation_95.
  ///
  /// In en, this message translates to:
  /// **'I am a true friend and a loyal partner.'**
  String get affirmation_95;

  /// No description provided for @affirmation_96.
  ///
  /// In en, this message translates to:
  /// **'I am a beautiful mind with a kind heart.'**
  String get affirmation_96;

  /// No description provided for @affirmation_97.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful, strong, and resilient person.'**
  String get affirmation_97;

  /// No description provided for @affirmation_98.
  ///
  /// In en, this message translates to:
  /// **'I am a beacon of hope and love.'**
  String get affirmation_98;

  /// No description provided for @affirmation_99.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful manifestor.'**
  String get affirmation_99;

  /// No description provided for @affirmation_100.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for amazing opportunities.'**
  String get affirmation_100;

  /// No description provided for @affirmation_101.
  ///
  /// In en, this message translates to:
  /// **'I am a true hero in my own story.'**
  String get affirmation_101;

  /// No description provided for @affirmation_102.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful and successful person.'**
  String get affirmation_102;

  /// No description provided for @affirmation_103.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for positive people and experiences.'**
  String get affirmation_103;

  /// No description provided for @affirmation_104.
  ///
  /// In en, this message translates to:
  /// **'I am a warrior, not a victim.'**
  String get affirmation_104;

  /// No description provided for @affirmation_105.
  ///
  /// In en, this message translates to:
  /// **'I am a powerful and influential force for good.'**
  String get affirmation_105;

  /// No description provided for @affirmation_106.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for blessings.'**
  String get affirmation_106;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
