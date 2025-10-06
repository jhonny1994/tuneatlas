import 'package:tuneatlas/src/src.dart';

abstract class StationRepository {
  /// Fetches a paginated list of the most popular stations by vote count.
  Future<List<Station>> fetchTopVotedStations({int offset = 0, int limit = 20});

  /// Fetches a paginated list of stations for a specific country code.
  Future<List<Station>> fetchStationsByCountry({
    required String code,
    int offset = 0,
    int limit = 20,
  });

  /// Fetches a paginated list of stations matching a specific tag/genre.
  Future<List<Station>> fetchStationsByTag({
    required String tag,
    int offset = 0,
    int limit = 20,
  });

  /// Fetches a paginated list of stations in a specific language.
  Future<List<Station>> fetchStationsByLanguage({
    required String language,
    int offset = 0,
    int limit = 20,
  });

  /// Searches for stations by name.
  Future<List<Station>> searchStationsByName({
    required String name,
    int offset = 0,
    int limit = 20,
  });
}
