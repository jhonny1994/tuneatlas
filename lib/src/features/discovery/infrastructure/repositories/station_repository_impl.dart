import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'station_repository_impl.g.dart';

class StationRepositoryImpl implements StationRepository {
  StationRepositoryImpl(this._dataSource);
  final StationRemoteDataSource _dataSource;

  Future<List<Station>> _fetchAndParseStations({
    required String path,
    int offset = 0,
    int limit = 20,
    String? searchTerm,
  }) async {
    final jsonList = await _dataSource.getStations(
      path: path,
      offset: offset,
      limit: limit,
      searchTerm: searchTerm,
    );
    return jsonList
        .map((json) => Station.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Station>> fetchTopVotedStations({
    int offset = 0,
    int limit = 20,
  }) => _fetchAndParseStations(
    path: '/json/stations/topvote',
    offset: offset,
    limit: limit,
  );

  @override
  Future<List<Station>> fetchStationsByCountry({
    required String code,
    int offset = 0,
    int limit = 20,
  }) => _fetchAndParseStations(
    path: '/json/stations/bycountrycodeexact/$code',
    offset: offset,
    limit: limit,
  );

  @override
  Future<List<Station>> fetchStationsByTag({
    required String tag,
    int offset = 0,
    int limit = 20,
  }) => _fetchAndParseStations(
    path: '/json/stations/bytag/$tag',
    offset: offset,
    limit: limit,
  );

  @override
  Future<List<Station>> fetchStationsByLanguage({
    required String language,
    int offset = 0,
    int limit = 20,
  }) => _fetchAndParseStations(
    path: '/json/stations/bylanguage/$language',
    offset: offset,
    limit: limit,
  );

  @override
  Future<List<Station>> searchStationsByName({
    required String name,
    int offset = 0,
    int limit = 20,
  }) => _fetchAndParseStations(
    path: '/json/stations/search',
    searchTerm: name,
    offset: offset,
    limit: limit,
  );
}

@riverpod
StationRepository stationRepository(Ref ref) {
  return StationRepositoryImpl(ref.watch(stationRemoteDataSourceProvider));
}
