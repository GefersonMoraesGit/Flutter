
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get home;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @interviews.
  ///
  /// In en, this message translates to:
  /// **'Interviews'**
  String get interviews;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @follow_us.
  ///
  /// In en, this message translates to:
  /// **'Follow us on Instagram'**
  String get follow_us;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @text_size.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get text_size;

  /// No description provided for @headlines.
  ///
  /// In en, this message translates to:
  /// **'HEADLINES'**
  String get headlines;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'LATEST ARTICLES'**
  String get latest;

  /// No description provided for @by_type.
  ///
  /// In en, this message translates to:
  /// **'By music genre'**
  String get by_type;

  /// No description provided for @alternative.
  ///
  /// In en, this message translates to:
  /// **'Alternative'**
  String get alternative;

  /// No description provided for @electro.
  ///
  /// In en, this message translates to:
  /// **'Electro'**
  String get electro;

  /// No description provided for @ambient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get ambient;

  /// No description provided for @pop.
  ///
  /// In en, this message translates to:
  /// **'French Pop'**
  String get pop;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get see_more;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Liked articles'**
  String get likes;

  /// No description provided for @no_likes.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t like articles yet'**
  String get no_likes;

  /// No description provided for @newsletter_intro.
  ///
  /// In en, this message translates to:
  /// **'Select one or both newletters you\'d like to receive'**
  String get newsletter_intro;

  /// No description provided for @newsletter_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Type your email address'**
  String get newsletter_placeholder;

  /// No description provided for @newsletter_artist.
  ///
  /// In en, this message translates to:
  /// **'Haumea for artists (available soon)'**
  String get newsletter_artist;

  /// No description provided for @newsletter_haumea.
  ///
  /// In en, this message translates to:
  /// **'Haumea recap (every Friday)'**
  String get newsletter_haumea;

  /// No description provided for @newsletter_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get newsletter_submit;

  /// No description provided for @newsletter_sent.
  ///
  /// In en, this message translates to:
  /// **'Thanks! A confirmation email has been sent.'**
  String get newsletter_sent;

  /// No description provided for @sociallinks_title.
  ///
  /// In en, this message translates to:
  /// **'Follow us on'**
  String get sociallinks_title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  


// Lookup logic when only language code is specified.
switch (locale.languageCode) {
  case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
}


  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
