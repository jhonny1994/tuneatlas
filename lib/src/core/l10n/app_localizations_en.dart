// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TuneAtlas';

  @override
  String get codec => 'Codec';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get hq => 'HQ';

  @override
  String get votes => 'Votes';

  @override
  String get playNow => 'Play Now';

  @override
  String get moreOptions => 'More Options';

  @override
  String get shareStation => 'Share Station';

  @override
  String get stationDetails => 'Station Details';

  @override
  String get visitWebsite => 'Visit Website';

  @override
  String get stationOptions => 'Station Options';

  @override
  String tagsOverflow(int count) {
    return '+$count more';
  }

  @override
  String get localStations => 'Local Stations';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get loadingStations => 'Loading stations...';

  @override
  String get errorLoadingStations => 'Error loading stations';

  @override
  String get library => 'Library';

  @override
  String get favorites => 'Favorites';

  @override
  String get clearFavorites => 'Clear Favorites';

  @override
  String get clearFavoritesConfirmTitle => 'Clear All Favorites?';

  @override
  String clearFavoritesConfirmMessage(int count) {
    return 'This will remove all $count stations from your favorites. This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get noFavoritesTitle => 'No Favorites Yet';

  @override
  String get noFavoritesMessage =>
      'Tap the heart icon on any station to add it to your favorites';

  @override
  String get search => 'Search';

  @override
  String get searchStations => 'Search stations...';

  @override
  String searchResultsCount(int count) {
    return '$count results';
  }

  @override
  String get noSearchResultsTitle => 'No Results Found';

  @override
  String get noSearchResultsMessage =>
      'Try different keywords or browse by country';

  @override
  String get errorSearchingStations => 'Error searching stations';

  @override
  String get discover => 'Discover';

  @override
  String get countries => 'Countries';

  @override
  String get languages => 'Languages';

  @override
  String get tags => 'Tags';

  @override
  String countriesCount(int count) {
    return '$count countries';
  }

  @override
  String languagesCount(int count) {
    return '$count languages';
  }

  @override
  String tagsCount(int count) {
    return '$count tags';
  }

  @override
  String stationsCount(int count) {
    return '$count stations';
  }

  @override
  String get noCountriesTitle => 'No Countries Available';

  @override
  String get noLanguagesTitle => 'No Languages Available';

  @override
  String get noTagsTitle => 'No Tags Available';

  @override
  String filteredStationsBy(String filterType, String filterValue) {
    return '$filterType: $filterValue';
  }

  @override
  String get noStationsTitle => 'No Stations Found';

  @override
  String noStationsMessage(String filterType) {
    return 'No stations available for this $filterType';
  }

  @override
  String get welcomeTitle => 'Welcome to TuneAtlas';

  @override
  String get welcomeDescription =>
      'Discover and stream thousands of radio stations from around the world';

  @override
  String get exploreTitle => 'Explore by Country, Language & Tags';

  @override
  String get exploreDescription =>
      'Find stations that match your preferences and interests';

  @override
  String get favoritesTitle => 'Build Your Collection';

  @override
  String get favoritesDescription =>
      'Save your favorite stations for quick access anytime';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get initializingApp => 'Initializing app...';

  @override
  String get failedToInitialize => 'Failed to Initialize';

  @override
  String get retry => 'Retry';

  @override
  String get loadingStation => 'Loading station...';

  @override
  String get errorPlayingStation => 'Error playing station';

  @override
  String get errorTimeout => 'Connection timeout - Station may be offline';

  @override
  String get errorNotFound => 'Station not found or no longer available';

  @override
  String get errorForbidden => 'Access to this station is restricted';

  @override
  String get errorNetwork => 'Network connection error - Check your internet';

  @override
  String get errorFormat => 'Unsupported audio format';

  @override
  String get errorUnknown => 'An unexpected error occurred';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get unknown => 'Unknown';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noData => 'No data available';

  @override
  String get searchForStations => 'Search for radio stations';

  @override
  String get enterStationName => 'Enter a station name to search';

  @override
  String get playing => 'Playing';

  @override
  String get paused => 'Paused';

  @override
  String get ready => 'Ready!';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Play';

  @override
  String get home => 'Home';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get errorFailedToConnect =>
      'Failed to connect to radio stream - please try again';

  @override
  String get errorConnectionTimeout =>
      'Connection timeout - stream may be offline';

  @override
  String get errorStreamNotFound => 'Stream not found - station may be offline';

  @override
  String get errorAccessDenied =>
      'Access denied - stream requires authentication';

  @override
  String get errorNetworkIssue => 'Network error - check your connection';

  @override
  String get errorUnsupportedFormat => 'Unsupported audio format';

  @override
  String get errorFailedToPlay => 'Failed to play station';

  @override
  String get errorFailedToResume => 'Failed to resume playback';

  @override
  String stationsIn(String countryCode) {
    return 'Stations in $countryCode';
  }

  @override
  String get stations => 'Stations';

  @override
  String get emptyStateSemanticLabel => 'Empty state';

  @override
  String get errorSemanticLabel => 'Error';

  @override
  String get language => 'Language';

  @override
  String get liveRadio => 'Live Radio';

  @override
  String get radio => 'Radio';

  @override
  String get searchFailed => 'Search failed';

  @override
  String get failedToLoadMore => 'Failed to load more results';

  @override
  String get failedToLoadStations => 'Failed to load stations';

  @override
  String get streamTimeoutError =>
      'Stream connection timeout - server not responding';

  @override
  String get failedToConnectToServers =>
      'Failed to connect to Radio Browser servers. Please check your internet connection and try again.';
}
