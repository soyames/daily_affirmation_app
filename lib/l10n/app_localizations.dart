import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh')
  ];

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Daily Affirmations!'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'This app was created to help you build a positive mindset and boost your self-confidence every day.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Why Affirmations?'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Affirmations are powerful statements that can rewire your thoughts and help you overcome negativity.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'How to Use the App'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Read your daily affirmation, reflect on it, and let it inspire your day. Save your favorites and set reminders!'**
  String get onboardingDesc3;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

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

  /// No description provided for @affirmation_107.
  ///
  /// In en, this message translates to:
  /// **'I am open to the beauty of each new day.'**
  String get affirmation_107;

  /// No description provided for @affirmation_108.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the small joys in life.'**
  String get affirmation_108;

  /// No description provided for @affirmation_109.
  ///
  /// In en, this message translates to:
  /// **'I am learning to trust myself more each day.'**
  String get affirmation_109;

  /// No description provided for @affirmation_110.
  ///
  /// In en, this message translates to:
  /// **'I am worthy of achieving my dreams.'**
  String get affirmation_110;

  /// No description provided for @affirmation_111.
  ///
  /// In en, this message translates to:
  /// **'I am calm, centered, and in control.'**
  String get affirmation_111;

  /// No description provided for @affirmation_112.
  ///
  /// In en, this message translates to:
  /// **'I am surrounded by endless possibilities.'**
  String get affirmation_112;

  /// No description provided for @affirmation_113.
  ///
  /// In en, this message translates to:
  /// **'I am proud of the progress I make every day.'**
  String get affirmation_113;

  /// No description provided for @affirmation_114.
  ///
  /// In en, this message translates to:
  /// **'I am deserving of all the good things life has to offer.'**
  String get affirmation_114;

  /// No description provided for @affirmation_115.
  ///
  /// In en, this message translates to:
  /// **'I am a source of peace and positivity.'**
  String get affirmation_115;

  /// No description provided for @affirmation_116.
  ///
  /// In en, this message translates to:
  /// **'I am growing stronger with every challenge I face.'**
  String get affirmation_116;

  /// No description provided for @affirmation_117.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my unique talents and gifts.'**
  String get affirmation_117;

  /// No description provided for @affirmation_118.
  ///
  /// In en, this message translates to:
  /// **'I am a light in the lives of others.'**
  String get affirmation_118;

  /// No description provided for @affirmation_119.
  ///
  /// In en, this message translates to:
  /// **'I am free to create the life I desire.'**
  String get affirmation_119;

  /// No description provided for @affirmation_120.
  ///
  /// In en, this message translates to:
  /// **'I am patient with myself and my journey.'**
  String get affirmation_120;

  /// No description provided for @affirmation_121.
  ///
  /// In en, this message translates to:
  /// **'I am worthy of self-care and compassion.'**
  String get affirmation_121;

  /// No description provided for @affirmation_122.
  ///
  /// In en, this message translates to:
  /// **'I am open to new adventures and experiences.'**
  String get affirmation_122;

  /// No description provided for @affirmation_123.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the love I give and receive.'**
  String get affirmation_123;

  /// No description provided for @affirmation_124.
  ///
  /// In en, this message translates to:
  /// **'I am resilient in the face of adversity.'**
  String get affirmation_124;

  /// No description provided for @affirmation_125.
  ///
  /// In en, this message translates to:
  /// **'I am a magnet for happiness and joy.'**
  String get affirmation_125;

  /// No description provided for @affirmation_126.
  ///
  /// In en, this message translates to:
  /// **'I am learning and growing every day.'**
  String get affirmation_126;

  /// No description provided for @affirmation_127.
  ///
  /// In en, this message translates to:
  /// **'I am proud of who I am becoming.'**
  String get affirmation_127;

  /// No description provided for @affirmation_128.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the lessons life teaches me.'**
  String get affirmation_128;

  /// No description provided for @affirmation_129.
  ///
  /// In en, this message translates to:
  /// **'I am a creator of positive change.'**
  String get affirmation_129;

  /// No description provided for @affirmation_130.
  ///
  /// In en, this message translates to:
  /// **'I am at peace with where I am right now.'**
  String get affirmation_130;

  /// No description provided for @affirmation_131.
  ///
  /// In en, this message translates to:
  /// **'I am open to giving and receiving kindness.'**
  String get affirmation_131;

  /// No description provided for @affirmation_132.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my journey and my story.'**
  String get affirmation_132;

  /// No description provided for @affirmation_133.
  ///
  /// In en, this message translates to:
  /// **'I am confident in my ability to overcome obstacles.'**
  String get affirmation_133;

  /// No description provided for @affirmation_134.
  ///
  /// In en, this message translates to:
  /// **'I am surrounded by support and encouragement.'**
  String get affirmation_134;

  /// No description provided for @affirmation_135.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the abundance in my life.'**
  String get affirmation_135;

  /// No description provided for @affirmation_136.
  ///
  /// In en, this message translates to:
  /// **'I am a beacon of hope for myself and others.'**
  String get affirmation_136;

  /// No description provided for @affirmation_137.
  ///
  /// In en, this message translates to:
  /// **'I am worthy of forgiveness and understanding.'**
  String get affirmation_137;

  /// No description provided for @affirmation_138.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the present moment.'**
  String get affirmation_138;

  /// No description provided for @affirmation_139.
  ///
  /// In en, this message translates to:
  /// **'I am open to learning from every experience.'**
  String get affirmation_139;

  /// No description provided for @affirmation_140.
  ///
  /// In en, this message translates to:
  /// **'I am a source of inspiration and motivation.'**
  String get affirmation_140;

  /// No description provided for @affirmation_141.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my inner strength.'**
  String get affirmation_141;

  /// No description provided for @affirmation_142.
  ///
  /// In en, this message translates to:
  /// **'I am open to love in all its forms.'**
  String get affirmation_142;

  /// No description provided for @affirmation_143.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the opportunities that come my way.'**
  String get affirmation_143;

  /// No description provided for @affirmation_144.
  ///
  /// In en, this message translates to:
  /// **'I am a positive thinker and a problem solver.'**
  String get affirmation_144;

  /// No description provided for @affirmation_145.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my health and vitality.'**
  String get affirmation_145;

  /// No description provided for @affirmation_146.
  ///
  /// In en, this message translates to:
  /// **'I am open to new perspectives and ideas.'**
  String get affirmation_146;

  /// No description provided for @affirmation_147.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the beauty that surrounds me.'**
  String get affirmation_147;

  /// No description provided for @affirmation_148.
  ///
  /// In en, this message translates to:
  /// **'I am a loving and caring person.'**
  String get affirmation_148;

  /// No description provided for @affirmation_149.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the friendships in my life.'**
  String get affirmation_149;

  /// No description provided for @affirmation_150.
  ///
  /// In en, this message translates to:
  /// **'I am open to the flow of abundance.'**
  String get affirmation_150;

  /// No description provided for @affirmation_151.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the gift of today.'**
  String get affirmation_151;

  /// No description provided for @affirmation_152.
  ///
  /// In en, this message translates to:
  /// **'I am a unique and valuable individual.'**
  String get affirmation_152;

  /// No description provided for @affirmation_153.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my creative spirit.'**
  String get affirmation_153;

  /// No description provided for @affirmation_154.
  ///
  /// In en, this message translates to:
  /// **'I am open to positive change.'**
  String get affirmation_154;

  /// No description provided for @affirmation_155.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the peace in my heart.'**
  String get affirmation_155;

  /// No description provided for @affirmation_156.
  ///
  /// In en, this message translates to:
  /// **'I am a work in progress, and that\'s okay.'**
  String get affirmation_156;

  /// No description provided for @affirmation_157.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the courage to try new things.'**
  String get affirmation_157;

  /// No description provided for @affirmation_158.
  ///
  /// In en, this message translates to:
  /// **'I am open to the magic of new beginnings.'**
  String get affirmation_158;

  /// No description provided for @affirmation_159.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the wisdom I gain each day.'**
  String get affirmation_159;

  /// No description provided for @affirmation_160.
  ///
  /// In en, this message translates to:
  /// **'I am a source of joy and laughter.'**
  String get affirmation_160;

  /// No description provided for @affirmation_161.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the love that fills my life.'**
  String get affirmation_161;

  /// No description provided for @affirmation_162.
  ///
  /// In en, this message translates to:
  /// **'I am open to the lessons of the universe.'**
  String get affirmation_162;

  /// No description provided for @affirmation_163.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for my ability to adapt and grow.'**
  String get affirmation_163;

  /// No description provided for @affirmation_164.
  ///
  /// In en, this message translates to:
  /// **'I am a believer in my own potential.'**
  String get affirmation_164;

  /// No description provided for @affirmation_165.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the strength to keep going.'**
  String get affirmation_165;

  /// No description provided for @affirmation_166.
  ///
  /// In en, this message translates to:
  /// **'I am open to the wonders of the world.'**
  String get affirmation_166;

  /// No description provided for @affirmation_167.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the journey of self-discovery.'**
  String get affirmation_167;

  /// No description provided for @affirmation_168.
  ///
  /// In en, this message translates to:
  /// **'I am a dreamer and a doer.'**
  String get affirmation_168;

  /// No description provided for @affirmation_169.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the power of hope.'**
  String get affirmation_169;

  /// No description provided for @affirmation_170.
  ///
  /// In en, this message translates to:
  /// **'I am open to the adventure of life.'**
  String get affirmation_170;

  /// No description provided for @affirmation_171.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the beauty of nature.'**
  String get affirmation_171;

  /// No description provided for @affirmation_172.
  ///
  /// In en, this message translates to:
  /// **'I am a champion of my own happiness.'**
  String get affirmation_172;

  /// No description provided for @affirmation_173.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the support of my loved ones.'**
  String get affirmation_173;

  /// No description provided for @affirmation_174.
  ///
  /// In en, this message translates to:
  /// **'I am open to the possibilities of tomorrow.'**
  String get affirmation_174;

  /// No description provided for @affirmation_175.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the gift of resilience.'**
  String get affirmation_175;

  /// No description provided for @affirmation_176.
  ///
  /// In en, this message translates to:
  /// **'I am a seeker of truth and wisdom.'**
  String get affirmation_176;

  /// No description provided for @affirmation_177.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the light within me.'**
  String get affirmation_177;

  /// No description provided for @affirmation_178.
  ///
  /// In en, this message translates to:
  /// **'I am open to the blessings of each day.'**
  String get affirmation_178;

  /// No description provided for @affirmation_179.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the chance to start anew.'**
  String get affirmation_179;

  /// No description provided for @affirmation_180.
  ///
  /// In en, this message translates to:
  /// **'I am a lover of life and all it offers.'**
  String get affirmation_180;

  /// No description provided for @affirmation_181.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the peace I find in stillness.'**
  String get affirmation_181;

  /// No description provided for @affirmation_182.
  ///
  /// In en, this message translates to:
  /// **'I am open to the gifts of the present.'**
  String get affirmation_182;

  /// No description provided for @affirmation_183.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the lessons of the past.'**
  String get affirmation_183;

  /// No description provided for @affirmation_184.
  ///
  /// In en, this message translates to:
  /// **'I am a builder of dreams.'**
  String get affirmation_184;

  /// No description provided for @affirmation_185.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the joy of giving.'**
  String get affirmation_185;

  /// No description provided for @affirmation_186.
  ///
  /// In en, this message translates to:
  /// **'I am open to the love that surrounds me.'**
  String get affirmation_186;

  /// No description provided for @affirmation_187.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the beauty of my soul.'**
  String get affirmation_187;

  /// No description provided for @affirmation_188.
  ///
  /// In en, this message translates to:
  /// **'I am a creator of my own happiness.'**
  String get affirmation_188;

  /// No description provided for @affirmation_189.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the strength in my heart.'**
  String get affirmation_189;

  /// No description provided for @affirmation_190.
  ///
  /// In en, this message translates to:
  /// **'I am open to the adventure of self-growth.'**
  String get affirmation_190;

  /// No description provided for @affirmation_191.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the power of gratitude.'**
  String get affirmation_191;

  /// No description provided for @affirmation_192.
  ///
  /// In en, this message translates to:
  /// **'I am a light in the darkness.'**
  String get affirmation_192;

  /// No description provided for @affirmation_193.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the courage to be myself.'**
  String get affirmation_193;

  /// No description provided for @affirmation_194.
  ///
  /// In en, this message translates to:
  /// **'I am open to the beauty of change.'**
  String get affirmation_194;

  /// No description provided for @affirmation_195.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the love I share.'**
  String get affirmation_195;

  /// No description provided for @affirmation_196.
  ///
  /// In en, this message translates to:
  /// **'I am a source of comfort and care.'**
  String get affirmation_196;

  /// No description provided for @affirmation_197.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the journey ahead.'**
  String get affirmation_197;

  /// No description provided for @affirmation_198.
  ///
  /// In en, this message translates to:
  /// **'I am open to the wisdom of my heart.'**
  String get affirmation_198;

  /// No description provided for @affirmation_199.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the peace in my mind.'**
  String get affirmation_199;

  /// No description provided for @affirmation_200.
  ///
  /// In en, this message translates to:
  /// **'I am a believer in the power of dreams.'**
  String get affirmation_200;

  /// No description provided for @affirmation_201.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the beauty of each sunrise.'**
  String get affirmation_201;

  /// No description provided for @affirmation_202.
  ///
  /// In en, this message translates to:
  /// **'I am open to the lessons of love.'**
  String get affirmation_202;

  /// No description provided for @affirmation_203.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the strength to forgive.'**
  String get affirmation_203;

  /// No description provided for @affirmation_204.
  ///
  /// In en, this message translates to:
  /// **'I am a champion of kindness.'**
  String get affirmation_204;

  /// No description provided for @affirmation_205.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for the hope that guides me.'**
  String get affirmation_205;

  /// No description provided for @affirmation_206.
  ///
  /// In en, this message translates to:
  /// **'I am open to the miracles of life.'**
  String get affirmation_206;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Get reminded to read your daily affirmation'**
  String get enableNotifications;

  /// No description provided for @disableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to get daily reminders'**
  String get disableNotifications;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @changeTime.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeTime;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @offlineModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Using cached affirmations only'**
  String get offlineModeEnabled;

  /// No description provided for @offlineModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Download new affirmations from internet'**
  String get offlineModeDisabled;

  /// No description provided for @cacheStorage.
  ///
  /// In en, this message translates to:
  /// **'Cache Storage'**
  String get cacheStorage;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCache;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @totalAffirmations.
  ///
  /// In en, this message translates to:
  /// **'Total Affirmations'**
  String get totalAffirmations;

  /// No description provided for @languagesSupported.
  ///
  /// In en, this message translates to:
  /// **'Languages Supported'**
  String get languagesSupported;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @rateAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Help us improve by rating the app'**
  String get rateAppDescription;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts and suggestions'**
  String get sendFeedbackDescription;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonDescription.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available in a future update!'**
  String get comingSoonDescription;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache?'**
  String get clearCacheTitle;

  /// No description provided for @clearCacheDescription.
  ///
  /// In en, this message translates to:
  /// **'This will remove all cached affirmations. You\'ll need an internet connection to load new ones.'**
  String get clearCacheDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @streakMessage0.
  ///
  /// In en, this message translates to:
  /// **'Start your journey today! 🌟'**
  String get streakMessage0;

  /// No description provided for @streakMessage1.
  ///
  /// In en, this message translates to:
  /// **'Great start! Keep it up! 💪'**
  String get streakMessage1;

  /// No description provided for @streakMessageLow.
  ///
  /// In en, this message translates to:
  /// **'Building momentum! {days} days strong! 🔥'**
  String streakMessageLow(Object days);

  /// No description provided for @streakMessageMedium.
  ///
  /// In en, this message translates to:
  /// **'Amazing streak! {days} days of positivity! ⭐'**
  String streakMessageMedium(Object days);

  /// No description provided for @streakMessageHigh.
  ///
  /// In en, this message translates to:
  /// **'Incredible! {days} days of daily affirmations! 🏆'**
  String streakMessageHigh(Object days);

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @resetStreak.
  ///
  /// In en, this message translates to:
  /// **'Reset Streak'**
  String get resetStreak;

  /// No description provided for @resetStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Streak?'**
  String get resetStreakTitle;

  /// No description provided for @resetStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your current streak? This action cannot be undone.'**
  String get resetStreakDescription;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @unlimitedAffirmations.
  ///
  /// In en, this message translates to:
  /// **'🎉 Unlimited Affirmations! ({days}+ day streak)'**
  String unlimitedAffirmations(Object days);

  /// No description provided for @affirmationsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} affirmations remaining today'**
  String affirmationsRemaining(Object count);

  /// No description provided for @dailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all 20 affirmations for today! Build a 5-day streak for unlimited access'**
  String get dailyLimitReached;

  /// No description provided for @noSavedAffirmations.
  ///
  /// In en, this message translates to:
  /// **'No saved affirmations yet.'**
  String get noSavedAffirmations;

  /// No description provided for @noMatchingAffirmations.
  ///
  /// In en, this message translates to:
  /// **'No affirmations match your search.'**
  String get noMatchingAffirmations;

  /// No description provided for @searchFavorites.
  ///
  /// In en, this message translates to:
  /// **'Search your favorites...'**
  String get searchFavorites;

  /// No description provided for @savedFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved favorites'**
  String get savedFavorites;

  /// No description provided for @noCachedAffirmations.
  ///
  /// In en, this message translates to:
  /// **'No affirmations cached'**
  String get noCachedAffirmations;

  /// No description provided for @cacheStatus.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} affirmations cached'**
  String cacheStatus(Object count, Object max);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
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
