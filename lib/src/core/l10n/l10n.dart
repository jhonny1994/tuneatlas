// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `TuneAtlas`
  String get appName {
    return Intl.message(
      'TuneAtlas',
      name: 'appName',
      desc: 'Application name',
      args: [],
    );
  }

  /// `Codec`
  String get codec {
    return Intl.message(
      'Codec',
      name: 'codec',
      desc: 'Label for audio codec badge',
      args: [],
    );
  }

  /// `Bitrate`
  String get bitrate {
    return Intl.message(
      'Bitrate',
      name: 'bitrate',
      desc: 'Label for bitrate badge',
      args: [],
    );
  }

  /// `HQ`
  String get hq {
    return Intl.message(
      'HQ',
      name: 'hq',
      desc: 'High quality badge for bitrate >= 128kbps',
      args: [],
    );
  }

  /// `Votes`
  String get votes {
    return Intl.message(
      'Votes',
      name: 'votes',
      desc: 'Label for station votes/popularity',
      args: [],
    );
  }

  /// `Play Now`
  String get playNow {
    return Intl.message(
      'Play Now',
      name: 'playNow',
      desc: 'Button to start playing station',
      args: [],
    );
  }

  /// `More Options`
  String get moreOptions {
    return Intl.message(
      'More Options',
      name: 'moreOptions',
      desc: 'Button to show additional station options',
      args: [],
    );
  }

  /// `Share Station`
  String get shareStation {
    return Intl.message(
      'Share Station',
      name: 'shareStation',
      desc: 'Option to share station',
      args: [],
    );
  }

  /// `Station Details`
  String get stationDetails {
    return Intl.message(
      'Station Details',
      name: 'stationDetails',
      desc: 'Option to view station details',
      args: [],
    );
  }

  /// `Visit Website`
  String get visitWebsite {
    return Intl.message(
      'Visit Website',
      name: 'visitWebsite',
      desc: 'Option to open station website',
      args: [],
    );
  }

  /// `Station Options`
  String get stationOptions {
    return Intl.message(
      'Station Options',
      name: 'stationOptions',
      desc: 'Bottom sheet title for station options',
      args: [],
    );
  }

  /// `+{count} more`
  String tagsOverflow(int count) {
    return Intl.message(
      '+$count more',
      name: 'tagsOverflow',
      desc: 'Indicator showing number of additional tags',
      args: [count],
    );
  }

  /// `Local Stations`
  String get localStations {
    return Intl.message(
      'Local Stations',
      name: 'localStations',
      desc: 'Home screen title',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: 'Instruction for pull-to-refresh gesture',
      args: [],
    );
  }

  /// `Loading stations...`
  String get loadingStations {
    return Intl.message(
      'Loading stations...',
      name: 'loadingStations',
      desc: 'Loading indicator text',
      args: [],
    );
  }

  /// `Error loading stations`
  String get errorLoadingStations {
    return Intl.message(
      'Error loading stations',
      name: 'errorLoadingStations',
      desc: 'Error state title',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: 'Library screen title',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: 'Favorites tab title',
      args: [],
    );
  }

  /// `Clear Favorites`
  String get clearFavorites {
    return Intl.message(
      'Clear Favorites',
      name: 'clearFavorites',
      desc: 'Button to clear all favorites',
      args: [],
    );
  }

  /// `Clear All Favorites?`
  String get clearFavoritesConfirmTitle {
    return Intl.message(
      'Clear All Favorites?',
      name: 'clearFavoritesConfirmTitle',
      desc: 'Confirmation dialog title',
      args: [],
    );
  }

  /// `This will remove all {count} stations from your favorites. This action cannot be undone.`
  String clearFavoritesConfirmMessage(int count) {
    return Intl.message(
      'This will remove all $count stations from your favorites. This action cannot be undone.',
      name: 'clearFavoritesConfirmMessage',
      desc: 'Confirmation dialog message',
      args: [count],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel button text',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: 'Clear/delete confirmation button',
      args: [],
    );
  }

  /// `No Favorites Yet`
  String get noFavoritesTitle {
    return Intl.message(
      'No Favorites Yet',
      name: 'noFavoritesTitle',
      desc: 'Empty state title',
      args: [],
    );
  }

  /// `Tap the heart icon on any station to add it to your favorites`
  String get noFavoritesMessage {
    return Intl.message(
      'Tap the heart icon on any station to add it to your favorites',
      name: 'noFavoritesMessage',
      desc: 'Empty state message',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: 'Search screen title',
      args: [],
    );
  }

  /// `Search stations...`
  String get searchStations {
    return Intl.message(
      'Search stations...',
      name: 'searchStations',
      desc: 'Search input hint',
      args: [],
    );
  }

  /// `{count} results`
  String searchResultsCount(int count) {
    return Intl.message(
      '$count results',
      name: 'searchResultsCount',
      desc: 'Number of search results',
      args: [count],
    );
  }

  /// `No Results Found`
  String get noSearchResultsTitle {
    return Intl.message(
      'No Results Found',
      name: 'noSearchResultsTitle',
      desc: 'Empty search results title',
      args: [],
    );
  }

  /// `Try different keywords or browse by country`
  String get noSearchResultsMessage {
    return Intl.message(
      'Try different keywords or browse by country',
      name: 'noSearchResultsMessage',
      desc: 'Empty search results message',
      args: [],
    );
  }

  /// `Error searching stations`
  String get errorSearchingStations {
    return Intl.message(
      'Error searching stations',
      name: 'errorSearchingStations',
      desc: 'Search error state title',
      args: [],
    );
  }

  /// `Discover`
  String get discover {
    return Intl.message(
      'Discover',
      name: 'discover',
      desc: 'Discover screen title',
      args: [],
    );
  }

  /// `Countries`
  String get countries {
    return Intl.message(
      'Countries',
      name: 'countries',
      desc: 'Countries tab title',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: 'Languages tab title',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: 'Tags tab title', args: []);
  }

  /// `{count} countries`
  String countriesCount(int count) {
    return Intl.message(
      '$count countries',
      name: 'countriesCount',
      desc: 'Number of countries',
      args: [count],
    );
  }

  /// `{count} languages`
  String languagesCount(int count) {
    return Intl.message(
      '$count languages',
      name: 'languagesCount',
      desc: 'Number of languages',
      args: [count],
    );
  }

  /// `{count} tags`
  String tagsCount(int count) {
    return Intl.message(
      '$count tags',
      name: 'tagsCount',
      desc: 'Number of tags',
      args: [count],
    );
  }

  /// `{count} stations`
  String stationsCount(int count) {
    return Intl.message(
      '$count stations',
      name: 'stationsCount',
      desc: 'Number of stations in category',
      args: [count],
    );
  }

  /// `No Countries Available`
  String get noCountriesTitle {
    return Intl.message(
      'No Countries Available',
      name: 'noCountriesTitle',
      desc: 'Empty countries state',
      args: [],
    );
  }

  /// `No Languages Available`
  String get noLanguagesTitle {
    return Intl.message(
      'No Languages Available',
      name: 'noLanguagesTitle',
      desc: 'Empty languages state',
      args: [],
    );
  }

  /// `No Tags Available`
  String get noTagsTitle {
    return Intl.message(
      'No Tags Available',
      name: 'noTagsTitle',
      desc: 'Empty tags state',
      args: [],
    );
  }

  /// `{filterType}: {filterValue}`
  String filteredStationsBy(String filterType, String filterValue) {
    return Intl.message(
      '$filterType: $filterValue',
      name: 'filteredStationsBy',
      desc: 'Filtered stations screen title',
      args: [filterType, filterValue],
    );
  }

  /// `No Stations Found`
  String get noStationsTitle {
    return Intl.message(
      'No Stations Found',
      name: 'noStationsTitle',
      desc: 'Empty filtered stations state',
      args: [],
    );
  }

  /// `No stations available for this {filterType}`
  String noStationsMessage(String filterType) {
    return Intl.message(
      'No stations available for this $filterType',
      name: 'noStationsMessage',
      desc: 'Empty filtered stations message',
      args: [filterType],
    );
  }

  /// `Welcome to TuneAtlas`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to TuneAtlas',
      name: 'welcomeTitle',
      desc: 'First onboarding screen title',
      args: [],
    );
  }

  /// `Discover and stream thousands of radio stations from around the world`
  String get welcomeDescription {
    return Intl.message(
      'Discover and stream thousands of radio stations from around the world',
      name: 'welcomeDescription',
      desc: 'First onboarding screen description',
      args: [],
    );
  }

  /// `Explore by Country, Language & Tags`
  String get exploreTitle {
    return Intl.message(
      'Explore by Country, Language & Tags',
      name: 'exploreTitle',
      desc: 'Second onboarding screen title',
      args: [],
    );
  }

  /// `Find stations that match your preferences and interests`
  String get exploreDescription {
    return Intl.message(
      'Find stations that match your preferences and interests',
      name: 'exploreDescription',
      desc: 'Second onboarding screen description',
      args: [],
    );
  }

  /// `Build Your Collection`
  String get favoritesTitle {
    return Intl.message(
      'Build Your Collection',
      name: 'favoritesTitle',
      desc: 'Third onboarding screen title',
      args: [],
    );
  }

  /// `Save your favorite stations for quick access anytime`
  String get favoritesDescription {
    return Intl.message(
      'Save your favorite stations for quick access anytime',
      name: 'favoritesDescription',
      desc: 'Third onboarding screen description',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: 'Skip onboarding button',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: 'Next onboarding page button',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: 'Final onboarding button',
      args: [],
    );
  }

  /// `Initializing app...`
  String get initializingApp {
    return Intl.message(
      'Initializing app...',
      name: 'initializingApp',
      desc: 'Splash loading message',
      args: [],
    );
  }

  /// `Failed to Initialize`
  String get failedToInitialize {
    return Intl.message(
      'Failed to Initialize',
      name: 'failedToInitialize',
      desc: 'Initialization error title',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: 'Retry button text',
      args: [],
    );
  }

  /// `Loading station...`
  String get loadingStation {
    return Intl.message(
      'Loading station...',
      name: 'loadingStation',
      desc: 'Audio loading state',
      args: [],
    );
  }

  /// `Error playing station`
  String get errorPlayingStation {
    return Intl.message(
      'Error playing station',
      name: 'errorPlayingStation',
      desc: 'Generic playback error',
      args: [],
    );
  }

  /// `Connection timeout - Station may be offline`
  String get errorTimeout {
    return Intl.message(
      'Connection timeout - Station may be offline',
      name: 'errorTimeout',
      desc: 'Timeout error message',
      args: [],
    );
  }

  /// `Station not found or no longer available`
  String get errorNotFound {
    return Intl.message(
      'Station not found or no longer available',
      name: 'errorNotFound',
      desc: '404 error message',
      args: [],
    );
  }

  /// `Access to this station is restricted`
  String get errorForbidden {
    return Intl.message(
      'Access to this station is restricted',
      name: 'errorForbidden',
      desc: '403 error message',
      args: [],
    );
  }

  /// `Network connection error - Check your internet`
  String get errorNetwork {
    return Intl.message(
      'Network connection error - Check your internet',
      name: 'errorNetwork',
      desc: 'Network error message',
      args: [],
    );
  }

  /// `Unsupported audio format`
  String get errorFormat {
    return Intl.message(
      'Unsupported audio format',
      name: 'errorFormat',
      desc: 'Format error message',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get errorUnknown {
    return Intl.message(
      'An unexpected error occurred',
      name: 'errorUnknown',
      desc: 'Unknown error message',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: 'Generic error state title',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: 'Retry action button',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: 'Fallback for missing data',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: 'Generic loading text',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: 'Generic error text',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: 'Empty data state',
      args: [],
    );
  }

  /// `Search for radio stations`
  String get searchForStations {
    return Intl.message(
      'Search for radio stations',
      name: 'searchForStations',
      desc: 'Initial search screen message',
      args: [],
    );
  }

  /// `Enter a station name to search`
  String get enterStationName {
    return Intl.message(
      'Enter a station name to search',
      name: 'enterStationName',
      desc: 'Search screen instruction',
      args: [],
    );
  }

  /// `Playing`
  String get playing {
    return Intl.message(
      'Playing',
      name: 'playing',
      desc: 'Audio player status - currently playing',
      args: [],
    );
  }

  /// `Paused`
  String get paused {
    return Intl.message(
      'Paused',
      name: 'paused',
      desc: 'Audio player status - paused',
      args: [],
    );
  }

  /// `Ready!`
  String get ready {
    return Intl.message(
      'Ready!',
      name: 'ready',
      desc: 'Splash screen ready message',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: 'Pause button label',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: 'Play button label',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home navigation label',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: 'Offline indicator message',
      args: [],
    );
  }

  /// `Failed to connect to radio stream - please try again`
  String get errorFailedToConnect {
    return Intl.message(
      'Failed to connect to radio stream - please try again',
      name: 'errorFailedToConnect',
      desc: 'Connection failure error',
      args: [],
    );
  }

  /// `Connection timeout - stream may be offline`
  String get errorConnectionTimeout {
    return Intl.message(
      'Connection timeout - stream may be offline',
      name: 'errorConnectionTimeout',
      desc: 'Timeout error for service layer',
      args: [],
    );
  }

  /// `Stream not found - station may be offline`
  String get errorStreamNotFound {
    return Intl.message(
      'Stream not found - station may be offline',
      name: 'errorStreamNotFound',
      desc: '404 error for service layer',
      args: [],
    );
  }

  /// `Access denied - stream requires authentication`
  String get errorAccessDenied {
    return Intl.message(
      'Access denied - stream requires authentication',
      name: 'errorAccessDenied',
      desc: '403/401 error for service layer',
      args: [],
    );
  }

  /// `Network error - check your connection`
  String get errorNetworkIssue {
    return Intl.message(
      'Network error - check your connection',
      name: 'errorNetworkIssue',
      desc: 'Network error for service layer',
      args: [],
    );
  }

  /// `Unsupported audio format`
  String get errorUnsupportedFormat {
    return Intl.message(
      'Unsupported audio format',
      name: 'errorUnsupportedFormat',
      desc: 'Format error for service layer',
      args: [],
    );
  }

  /// `Failed to play station`
  String get errorFailedToPlay {
    return Intl.message(
      'Failed to play station',
      name: 'errorFailedToPlay',
      desc: 'Generic playback error for service layer',
      args: [],
    );
  }

  /// `Failed to resume playback`
  String get errorFailedToResume {
    return Intl.message(
      'Failed to resume playback',
      name: 'errorFailedToResume',
      desc: 'Resume playback error',
      args: [],
    );
  }

  /// `Stations in {countryCode}`
  String stationsIn(String countryCode) {
    return Intl.message(
      'Stations in $countryCode',
      name: 'stationsIn',
      desc: 'Home screen title with country code',
      args: [countryCode],
    );
  }

  /// `Stations`
  String get stations {
    return Intl.message(
      'Stations',
      name: 'stations',
      desc: 'Generic stations title fallback',
      args: [],
    );
  }

  /// `Empty state`
  String get emptyStateSemanticLabel {
    return Intl.message(
      'Empty state',
      name: 'emptyStateSemanticLabel',
      desc: 'Semantic label for empty state icon (accessibility)',
      args: [],
    );
  }

  /// `Error`
  String get errorSemanticLabel {
    return Intl.message(
      'Error',
      name: 'errorSemanticLabel',
      desc: 'Semantic label for error icon (accessibility)',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: 'Language settings label',
      args: [],
    );
  }

  /// `Live Radio`
  String get liveRadio {
    return Intl.message(
      'Live Radio',
      name: 'liveRadio',
      desc: 'Default album name for media notification',
      args: [],
    );
  }

  /// `Radio`
  String get radio {
    return Intl.message(
      'Radio',
      name: 'radio',
      desc: 'Default artist name for media notification when country is empty',
      args: [],
    );
  }

  /// `Search failed`
  String get searchFailed {
    return Intl.message(
      'Search failed',
      name: 'searchFailed',
      desc: 'Error message when search operation fails',
      args: [],
    );
  }

  /// `Failed to load more results`
  String get failedToLoadMore {
    return Intl.message(
      'Failed to load more results',
      name: 'failedToLoadMore',
      desc: 'Error message when pagination fails',
      args: [],
    );
  }

  /// `Failed to load stations`
  String get failedToLoadStations {
    return Intl.message(
      'Failed to load stations',
      name: 'failedToLoadStations',
      desc: 'Error message when station loading fails',
      args: [],
    );
  }

  /// `Stream connection timeout - server not responding`
  String get streamTimeoutError {
    return Intl.message(
      'Stream connection timeout - server not responding',
      name: 'streamTimeoutError',
      desc: 'Error message when stream connection times out',
      args: [],
    );
  }

  /// `Failed to connect to Radio Browser servers. Please check your internet connection and try again.`
  String get failedToConnectToServers {
    return Intl.message(
      'Failed to connect to Radio Browser servers. Please check your internet connection and try again.',
      name: 'failedToConnectToServers',
      desc: 'Initialization error message when unable to discover servers',
      args: [],
    );
  }

  /// `Check out {stationName} on TuneAtlas! {deepLink}`
  String shareMessage(String stationName, String deepLink) {
    return Intl.message(
      'Check out $stationName on TuneAtlas! $deepLink',
      name: 'shareMessage',
      desc: 'Message when sharing a station',
      args: [stationName, deepLink],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
