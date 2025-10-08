import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';

part 'radio_browser_api_provider.g.dart';

/// Provides RadioBrowserApi instance
/// Depends on ApiClient
@Riverpod(keepAlive: true)
RadioBrowserApi radioBrowserApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RadioBrowserApi(apiClient);
}
