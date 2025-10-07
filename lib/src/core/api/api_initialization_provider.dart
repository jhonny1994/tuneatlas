import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';

part 'api_initialization_provider.g.dart';

/// Initializes the API client with a discovered server
/// Must be called before making any API requests
@riverpod
Future<bool> apiInitialization(Ref ref) async {
  try {
    // Discover server
    final serverDiscovery = ref.watch(serverDiscoveryProvider);
    final serverUrl = await serverDiscovery.discoverServer();

    // Update API client with discovered server
    ref.watch(apiClientProvider).updateBaseUrl(serverUrl);

    return true;
  } on Exception {
    // Log error and return false
    return false;
  }
}
