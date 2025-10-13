import 'package:flutter/foundation.dart';
import 'package:tuneatlas/src/src.dart';

/// Radio Browser API service
/// Provides methods to fetch stations, countries, languages, tags, etc.
class RadioBrowserApi {
  RadioBrowserApi(this._apiClient);

  final ApiClient _apiClient;

  /// Get stations by country
  Future<Result<List<Station>>> getStationsByCountry({
    required String countryCode,
    int limit = 100,
    int offset = 0,
    bool hidebroken = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/json/stations/bycountrycodeexact/$countryCode',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'order': 'votes',
          'reverse': 'true',
          'hidebroken': hidebroken.toString(),
        },
      );

      final stations = (response.data as List)
          .map((json) => Station.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(stations);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching stations by country: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load stations');
    }
  }

  /// Get stations by language
  Future<Result<List<Station>>> getStationsByLanguage({
    required String language,
    int limit = 100,
    int offset = 0,
    bool hidebroken = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/json/stations/bylanguageexact/$language',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'order': 'votes',
          'reverse': 'true',
          'hidebroken': hidebroken.toString(),
        },
      );

      final stations = (response.data as List)
          .map((json) => Station.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(stations);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching stations by language: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load stations');
    }
  }

  /// Get stations by tag
  Future<Result<List<Station>>> getStationsByTag({
    required String tag,
    int limit = 100,
    int offset = 0,
    bool hidebroken = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/json/stations/bytagexact/$tag',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'order': 'votes',
          'reverse': 'true',
          'hidebroken': hidebroken.toString(),
        },
      );

      final stations = (response.data as List)
          .map((json) => Station.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(stations);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching stations by tag: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load stations');
    }
  }

  /// Search stations by name
  Future<Result<List<Station>>> searchStations({
    required String query,
    int limit = 100,
    int offset = 0,
    bool hidebroken = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/json/stations/byname/$query',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'order': 'votes',
          'reverse': 'true',
          'hidebroken': hidebroken.toString(),
        },
      );

      final stations = (response.data as List)
          .map((json) => Station.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(stations);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error searching stations: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to search stations');
    }
  }

  /// Get top voted stations
  Future<Result<List<Station>>> getTopVotedStations({
    int limit = 100,
    int offset = 0,
    bool hidebroken = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/json/stations/topvote',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'hidebroken': hidebroken.toString(),
        },
      );

      final stations = (response.data as List)
          .map((json) => Station.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(stations);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching top voted stations: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load stations');
    }
  }

  /// Get all countries
  Future<Result<List<Facet>>> getCountries() async {
    try {
      final response = await _apiClient.get('/json/countries');

      final countries = (response.data as List)
          .map((json) => Facet.fromJson(json as Map<String, dynamic>))
          .toList()
        // Sort by station count descending
        ..sort((a, b) => b.stationCount.compareTo(a.stationCount));

      return Result.success(countries);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching countries: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load countries');
    }
  }

  /// Get all languages
  Future<Result<List<Facet>>> getLanguages() async {
    try {
      final response = await _apiClient.get('/json/languages');

      final languages = (response.data as List)
          .map((json) => Facet.fromJson(json as Map<String, dynamic>))
          .toList()
        // Sort by station count descending
        ..sort((a, b) => b.stationCount.compareTo(a.stationCount));

      return Result.success(languages);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching languages: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load languages');
    }
  }

  /// Get all tags
  Future<Result<List<Facet>>> getTags() async {
    try {
      final response = await _apiClient.get('/json/tags');

      final tags = (response.data as List)
          .map((json) => Facet.fromJson(json as Map<String, dynamic>))
          .toList()
        // Sort by station count descending
        ..sort((a, b) => b.stationCount.compareTo(a.stationCount));

      return Result.success(tags);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error fetching tags: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to load tags');
    }
  }

  /// Vote for a station (increases popularity)
  Future<Result<void>> voteForStation(String stationUuid) async {
    try {
      await _apiClient.get('/json/vote/$stationUuid');
      return const Result.success(null);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error voting for station: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to vote');
    }
  }

  /// Track station click (call when user starts playing a station)
  /// This helps Radio Browser track station popularity
  /// Counts once per IP per station per day
  Future<Result<void>> trackStationClick(String stationUuid) async {
    try {
      await _apiClient.get('/json/url/$stationUuid');
      debugPrint('[RadioBrowserApi] Station click tracked: $stationUuid');
      return const Result.success(null);
    } on ApiException catch (e) {
      debugPrint('[RadioBrowserApi] Error tracking station click: $e');
      return Result.failure(e.message);
    } on Exception catch (e) {
      debugPrint('[RadioBrowserApi] Unexpected error: $e');
      return const Result.failure('Failed to track click');
    }
  }
}
