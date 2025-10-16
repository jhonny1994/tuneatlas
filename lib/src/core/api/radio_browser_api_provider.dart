import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'radio_browser_api_provider.g.dart';

/// Provides RadioBrowserApi instance
/// Depends on ApiClient
///
/// Note: The ApiClient's base URL is set during app initialization.
/// The router guards navigation until initialization is complete,
/// preventing API calls before the server URL is configured.
@Riverpod(keepAlive: true)
RadioBrowserApi radioBrowserApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RadioBrowserApi(apiClient);
}
