// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "This will remove all ${count} stations from your favorites. This action cannot be undone.";

  static String m1(count) => "${count} countries";

  static String m2(filterType, filterValue) => "${filterType}: ${filterValue}";

  static String m3(count) => "${count} languages";

  static String m4(filterType) =>
      "No stations available for this ${filterType}";

  static String m5(stationName) => "Now playing: ${stationName}";

  static String m6(count) => "${count} results";

  static String m7(stationName, deepLink) =>
      "Check out ${stationName} on TuneAtlas! ${deepLink}";

  static String m8(stationName, country) => "${stationName}, ${country}";

  static String m9(count) => "${count} stations";

  static String m10(countryCode) => "Stations in ${countryCode}";

  static String m11(count) => "${count} tags";

  static String m12(count) => "+${count} more";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addToFavoritesLabel": MessageLookupByLibrary.simpleMessage(
      "Add to favorites",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("TuneAtlas"),
    "bitrate": MessageLookupByLibrary.simpleMessage("Bitrate"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearFavorites": MessageLookupByLibrary.simpleMessage("Clear Favorites"),
    "clearFavoritesConfirmMessage": m0,
    "clearFavoritesConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Clear All Favorites?",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("Codec"),
    "countries": MessageLookupByLibrary.simpleMessage("Countries"),
    "countriesCount": m1,
    "discover": MessageLookupByLibrary.simpleMessage("Discover"),
    "emptyStateSemanticLabel": MessageLookupByLibrary.simpleMessage(
      "Empty state",
    ),
    "enterStationName": MessageLookupByLibrary.simpleMessage(
      "Enter a station name to search",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorAccessDenied": MessageLookupByLibrary.simpleMessage(
      "Access denied - stream requires authentication",
    ),
    "errorConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timeout - stream may be offline",
    ),
    "errorFailedToConnect": MessageLookupByLibrary.simpleMessage(
      "Failed to connect to radio stream - please try again",
    ),
    "errorFailedToPlay": MessageLookupByLibrary.simpleMessage(
      "Failed to play station",
    ),
    "errorFailedToResume": MessageLookupByLibrary.simpleMessage(
      "Failed to resume playback",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage(
      "Access to this station is restricted",
    ),
    "errorFormat": MessageLookupByLibrary.simpleMessage(
      "Unsupported audio format",
    ),
    "errorLoadingStations": MessageLookupByLibrary.simpleMessage(
      "Error loading stations",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "Network connection error - Check your internet",
    ),
    "errorNetworkIssue": MessageLookupByLibrary.simpleMessage(
      "Network error - check your connection",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage(
      "Station not found or no longer available",
    ),
    "errorPlayingStation": MessageLookupByLibrary.simpleMessage(
      "Error playing station",
    ),
    "errorSearchingStations": MessageLookupByLibrary.simpleMessage(
      "Error searching stations",
    ),
    "errorSemanticLabel": MessageLookupByLibrary.simpleMessage("Error"),
    "errorStreamNotFound": MessageLookupByLibrary.simpleMessage(
      "Stream not found - station may be offline",
    ),
    "errorTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timeout - Station may be offline",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred",
    ),
    "errorUnsupportedFormat": MessageLookupByLibrary.simpleMessage(
      "Unsupported audio format",
    ),
    "exploreDescription": MessageLookupByLibrary.simpleMessage(
      "Find stations that match your preferences and interests",
    ),
    "exploreTitle": MessageLookupByLibrary.simpleMessage(
      "Explore by Country, Language & Tags",
    ),
    "failedToConnectToServers": MessageLookupByLibrary.simpleMessage(
      "Failed to connect to Radio Browser servers. Please check your internet connection and try again.",
    ),
    "failedToInitialize": MessageLookupByLibrary.simpleMessage(
      "Failed to Initialize",
    ),
    "failedToLoadMore": MessageLookupByLibrary.simpleMessage(
      "Failed to load more results",
    ),
    "failedToLoadStations": MessageLookupByLibrary.simpleMessage(
      "Failed to load stations",
    ),
    "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
    "favoritesDescription": MessageLookupByLibrary.simpleMessage(
      "Save your favorite stations for quick access anytime",
    ),
    "favoritesTitle": MessageLookupByLibrary.simpleMessage(
      "Build Your Collection",
    ),
    "filteredStationsBy": m2,
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hq": MessageLookupByLibrary.simpleMessage("HQ"),
    "initializingApp": MessageLookupByLibrary.simpleMessage(
      "Initializing app...",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languages": MessageLookupByLibrary.simpleMessage("Languages"),
    "languagesCount": m3,
    "library": MessageLookupByLibrary.simpleMessage("Library"),
    "liveRadio": MessageLookupByLibrary.simpleMessage("Live Radio"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loadingStation": MessageLookupByLibrary.simpleMessage(
      "Loading station...",
    ),
    "loadingStations": MessageLookupByLibrary.simpleMessage(
      "Loading stations...",
    ),
    "localStations": MessageLookupByLibrary.simpleMessage("Local Stations"),
    "moreOptions": MessageLookupByLibrary.simpleMessage("More Options"),
    "moreOptionsLabel": MessageLookupByLibrary.simpleMessage("More options"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noCountriesTitle": MessageLookupByLibrary.simpleMessage(
      "No Countries Available",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("No data available"),
    "noFavoritesMessage": MessageLookupByLibrary.simpleMessage(
      "Tap the heart icon on any station to add it to your favorites",
    ),
    "noFavoritesTitle": MessageLookupByLibrary.simpleMessage(
      "No Favorites Yet",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "noLanguagesTitle": MessageLookupByLibrary.simpleMessage(
      "No Languages Available",
    ),
    "noSearchResultsMessage": MessageLookupByLibrary.simpleMessage(
      "Try different keywords or browse by country",
    ),
    "noSearchResultsTitle": MessageLookupByLibrary.simpleMessage(
      "No Results Found",
    ),
    "noStationsMessage": m4,
    "noStationsTitle": MessageLookupByLibrary.simpleMessage(
      "No Stations Found",
    ),
    "noTagsTitle": MessageLookupByLibrary.simpleMessage("No Tags Available"),
    "nowPlayingLabel": m5,
    "pause": MessageLookupByLibrary.simpleMessage("Pause"),
    "pauseButtonLabel": MessageLookupByLibrary.simpleMessage("Pause"),
    "paused": MessageLookupByLibrary.simpleMessage("Paused"),
    "play": MessageLookupByLibrary.simpleMessage("Play"),
    "playButtonLabel": MessageLookupByLibrary.simpleMessage("Play"),
    "playNow": MessageLookupByLibrary.simpleMessage("Play Now"),
    "playing": MessageLookupByLibrary.simpleMessage("Playing"),
    "pullToRefresh": MessageLookupByLibrary.simpleMessage("Pull to refresh"),
    "radio": MessageLookupByLibrary.simpleMessage("Radio"),
    "ready": MessageLookupByLibrary.simpleMessage("Ready!"),
    "removeFromFavoritesLabel": MessageLookupByLibrary.simpleMessage(
      "Remove from favorites",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "retryButtonLabel": MessageLookupByLibrary.simpleMessage("Retry"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchFailed": MessageLookupByLibrary.simpleMessage("Search failed"),
    "searchForStations": MessageLookupByLibrary.simpleMessage(
      "Search for radio stations",
    ),
    "searchResultsCount": m6,
    "searchStations": MessageLookupByLibrary.simpleMessage(
      "Search stations...",
    ),
    "shareButtonLabel": MessageLookupByLibrary.simpleMessage("Share station"),
    "shareMessage": m7,
    "shareStation": MessageLookupByLibrary.simpleMessage("Share Station"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "stationCardLabel": m8,
    "stationDetails": MessageLookupByLibrary.simpleMessage("Station Details"),
    "stationOptions": MessageLookupByLibrary.simpleMessage("Station Options"),
    "stations": MessageLookupByLibrary.simpleMessage("Stations"),
    "stationsCount": m9,
    "stationsIn": m10,
    "stopButtonLabel": MessageLookupByLibrary.simpleMessage("Stop playback"),
    "streamTimeoutError": MessageLookupByLibrary.simpleMessage(
      "Stream connection timeout - server not responding",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
    "tagsCount": m11,
    "tagsOverflow": m12,
    "toggleThemeLabel": MessageLookupByLibrary.simpleMessage("Toggle theme"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "visitWebsite": MessageLookupByLibrary.simpleMessage("Visit Website"),
    "votes": MessageLookupByLibrary.simpleMessage("Votes"),
    "welcomeDescription": MessageLookupByLibrary.simpleMessage(
      "Discover and stream thousands of radio stations from around the world",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "Welcome to TuneAtlas",
    ),
  };
}
