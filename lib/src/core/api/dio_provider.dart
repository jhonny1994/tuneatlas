import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'dio_provider.g.dart';

/// Provides a single configured Dio instance for the entire app.
///
/// This ensures:
/// - Single HTTP client instance (connection pooling)
/// - Consistent configuration across all API calls
/// - Easy mocking for testing
/// - Centralized timeout and header management
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.requestTimeout,
      headers: {
        'User-Agent': AppConfig.userAgent,
        'Content-Type': 'application/json',
      },
    ),
  );
}
