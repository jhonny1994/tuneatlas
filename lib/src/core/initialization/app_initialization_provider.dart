import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'app_initialization_provider.g.dart';

/// Manages app initialization process
/// Discovers Radio Browser server and initializes API client
@riverpod
class AppInitialization extends _$AppInitialization {
  @override
  AppInitializationState build() {
    // Start initialization immediately
    unawaited(_initialize());
    return const AppInitializationState.loading();
  }

  /// Initialize the app
  Future<void> _initialize() async {
    try {
      // Discover Radio Browser server
      final serverDiscovery = ref.read(serverDiscoveryProvider);
      final serverUrl = await serverDiscovery.discoverServer();

      // Update API client with discovered server
      ref.read(apiClientProvider).updateBaseUrl(serverUrl);

      // Small delay for splash screen visibility (optional)
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Success!
      state = const AppInitializationState.success();
    } on Exception {
      // Use a generic error key that exists in localization
      state = const AppInitializationState.error(
        'errorFailedToConnect',
      );
    }
  }

  /// Retry initialization (called when user taps retry button)
  Future<void> retry() async {
    state = const AppInitializationState.loading();
    await _initialize();
  }
}
