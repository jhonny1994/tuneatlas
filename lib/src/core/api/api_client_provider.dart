import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'api_client_provider.g.dart';

/// Provides a single instance of ApiClient
/// Singleton pattern - same instance used everywhere
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient();
}
