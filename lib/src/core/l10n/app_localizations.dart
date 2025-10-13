import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('en')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'TuneAtlas'**
  String get appName;

  /// Label for audio codec badge
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get codec;

  /// Label for bitrate badge
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get bitrate;

  /// High quality badge for bitrate >= 128kbps
  ///
  /// In en, this message translates to:
  /// **'HQ'**
  String get hq;

  /// Label for station votes/popularity
  ///
  /// In en, this message translates to:
  /// **'Votes'**
  String get votes;

  /// Button to start playing station
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get playNow;

  /// Button to show additional station options
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// Option to share station
  ///
  /// In en, this message translates to:
  /// **'Share Station'**
  String get shareStation;

  /// Option to view station details
  ///
  /// In en, this message translates to:
  /// **'Station Details'**
  String get stationDetails;

  /// Option to open station website
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// Bottom sheet title for station options
  ///
  /// In en, this message translates to:
  /// **'Station Options'**
  String get stationOptions;

  /// Indicator showing number of additional tags
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String tagsOverflow(int count);

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Local Stations'**
  String get localStations;

  /// Instruction for pull-to-refresh gesture
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading stations...'**
  String get loadingStations;

  /// Error state title
  ///
  /// In en, this message translates to:
  /// **'Error loading stations'**
  String get errorLoadingStations;

  /// Library screen title
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Favorites tab title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Button to clear all favorites
  ///
  /// In en, this message translates to:
  /// **'Clear Favorites'**
  String get clearFavorites;

  /// Confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear All Favorites?'**
  String get clearFavoritesConfirmTitle;

  /// Confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This will remove all {count} stations from your favorites. This action cannot be undone.'**
  String clearFavoritesConfirmMessage(int count);

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Clear/delete confirmation button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesTitle;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any station to add it to your favorites'**
  String get noFavoritesMessage;

  /// Search screen title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search input hint
  ///
  /// In en, this message translates to:
  /// **'Search stations...'**
  String get searchStations;

  /// Number of search results
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String searchResultsCount(int count);

  /// Empty search results title
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noSearchResultsTitle;

  /// Empty search results message
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or browse by country'**
  String get noSearchResultsMessage;

  /// Search error state title
  ///
  /// In en, this message translates to:
  /// **'Error searching stations'**
  String get errorSearchingStations;

  /// Discover screen title
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Countries tab title
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// Languages tab title
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Tags tab title
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Number of countries
  ///
  /// In en, this message translates to:
  /// **'{count} countries'**
  String countriesCount(int count);

  /// Number of languages
  ///
  /// In en, this message translates to:
  /// **'{count} languages'**
  String languagesCount(int count);

  /// Number of tags
  ///
  /// In en, this message translates to:
  /// **'{count} tags'**
  String tagsCount(int count);

  /// Number of stations in category
  ///
  /// In en, this message translates to:
  /// **'{count} stations'**
  String stationsCount(int count);

  /// Empty countries state
  ///
  /// In en, this message translates to:
  /// **'No Countries Available'**
  String get noCountriesTitle;

  /// Empty languages state
  ///
  /// In en, this message translates to:
  /// **'No Languages Available'**
  String get noLanguagesTitle;

  /// Empty tags state
  ///
  /// In en, this message translates to:
  /// **'No Tags Available'**
  String get noTagsTitle;

  /// Filtered stations screen title
  ///
  /// In en, this message translates to:
  /// **'{filterType}: {filterValue}'**
  String filteredStationsBy(String filterType, String filterValue);

  /// Empty filtered stations state
  ///
  /// In en, this message translates to:
  /// **'No Stations Found'**
  String get noStationsTitle;

  /// Empty filtered stations message
  ///
  /// In en, this message translates to:
  /// **'No stations available for this {filterType}'**
  String noStationsMessage(String filterType);

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to TuneAtlas'**
  String get welcomeTitle;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Discover and stream thousands of radio stations from around the world'**
  String get welcomeDescription;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Explore by Country, Language & Tags'**
  String get exploreTitle;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Find stations that match your preferences and interests'**
  String get exploreDescription;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Build Your Collection'**
  String get favoritesTitle;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Save your favorite stations for quick access anytime'**
  String get favoritesDescription;

  /// Skip onboarding button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next onboarding page button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Final onboarding button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Splash loading message
  ///
  /// In en, this message translates to:
  /// **'Initializing app...'**
  String get initializingApp;

  /// Initialization error title
  ///
  /// In en, this message translates to:
  /// **'Failed to Initialize'**
  String get failedToInitialize;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Audio loading state
  ///
  /// In en, this message translates to:
  /// **'Loading station...'**
  String get loadingStation;

  /// Generic playback error
  ///
  /// In en, this message translates to:
  /// **'Error playing station'**
  String get errorPlayingStation;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'Connection timeout - Station may be offline'**
  String get errorTimeout;

  /// 404 error message
  ///
  /// In en, this message translates to:
  /// **'Station not found or no longer available'**
  String get errorNotFound;

  /// 403 error message
  ///
  /// In en, this message translates to:
  /// **'Access to this station is restricted'**
  String get errorForbidden;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network connection error - Check your internet'**
  String get errorNetwork;

  /// Format error message
  ///
  /// In en, this message translates to:
  /// **'Unsupported audio format'**
  String get errorFormat;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnknown;

  /// Generic error state title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Retry action button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Fallback for missing data
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Generic loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Empty data state
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Initial search screen message
  ///
  /// In en, this message translates to:
  /// **'Search for radio stations'**
  String get searchForStations;

  /// Search screen instruction
  ///
  /// In en, this message translates to:
  /// **'Enter a station name to search'**
  String get enterStationName;

  /// Audio player status - currently playing
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// Audio player status - paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Splash screen ready message
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get ready;

  /// Pause button label
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Play button label
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Offline indicator message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Connection failure error
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to radio stream - please try again'**
  String get errorFailedToConnect;

  /// Timeout error for service layer
  ///
  /// In en, this message translates to:
  /// **'Connection timeout - stream may be offline'**
  String get errorConnectionTimeout;

  /// 404 error for service layer
  ///
  /// In en, this message translates to:
  /// **'Stream not found - station may be offline'**
  String get errorStreamNotFound;

  /// 403/401 error for service layer
  ///
  /// In en, this message translates to:
  /// **'Access denied - stream requires authentication'**
  String get errorAccessDenied;

  /// Network error for service layer
  ///
  /// In en, this message translates to:
  /// **'Network error - check your connection'**
  String get errorNetworkIssue;

  /// Format error for service layer
  ///
  /// In en, this message translates to:
  /// **'Unsupported audio format'**
  String get errorUnsupportedFormat;

  /// Generic playback error for service layer
  ///
  /// In en, this message translates to:
  /// **'Failed to play station'**
  String get errorFailedToPlay;

  /// Resume playback error
  ///
  /// In en, this message translates to:
  /// **'Failed to resume playback'**
  String get errorFailedToResume;

  /// Home screen title with country code
  ///
  /// In en, this message translates to:
  /// **'Stations in {countryCode}'**
  String stationsIn(String countryCode);

  /// Generic stations title fallback
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stations;

  /// Semantic label for empty state icon (accessibility)
  ///
  /// In en, this message translates to:
  /// **'Empty state'**
  String get emptyStateSemanticLabel;

  /// Semantic label for error icon (accessibility)
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorSemanticLabel;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
