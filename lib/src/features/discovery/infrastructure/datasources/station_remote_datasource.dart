import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'station_remote_datasource.g.dart';

class StationRemoteDataSource {
  StationRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<dynamic>> _get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<List<dynamic>>(
      path,
      queryParameters: query,
    );
    return response.data ?? [];
  }

  Future<List<dynamic>> getStations({
    required String path,
    int offset = 0,
    int limit = 20,
    String? searchTerm,
  }) {
    final query = {
      'offset': offset,
      'limit': limit,
      'name': ?searchTerm,
      'hidebroken': 'true',
    };
    return _get(path, query: query);
  }
}

@riverpod
StationRemoteDataSource stationRemoteDataSource(
  Ref ref,
) {
  return StationRemoteDataSource(ref.watch(dioProvider));
}
