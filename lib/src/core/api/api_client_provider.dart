import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'api_client_provider.g.dart';

/// Provides a single instance of ApiClient with injected Dio.
///
/// The Dio instance is obtained from [dioProvider] to ensure
/// a single HTTP client instance is used throughout the app.
/// This provides:
/// - Connection pooling
/// - Consistent configuration
/// - Easy testing with mocked Dio
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
}
