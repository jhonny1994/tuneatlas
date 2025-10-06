import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      headers: {'User-Agent': 'TuneAtlas/1.0.0'},
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  dio.interceptors.add(RadioBrowserInterceptor());
  return dio;
}
