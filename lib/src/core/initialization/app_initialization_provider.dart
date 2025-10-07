import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/api/api_client_provider.dart';
import 'package:tuneatlas/src/core/api/server_discovery_provider.dart';
import 'package:tuneatlas/src/core/initialization/app_initialization_state.dart';

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
      debugPrint('[AppInitialization] Starting initialization...');

      // Discover Radio Browser server
      final serverDiscovery = ref.read(serverDiscoveryProvider);
      final serverUrl = await serverDiscovery.discoverServer();

      debugPrint('[AppInitialization] Server discovered: $serverUrl');

      // Update API client with discovered server
      ref.read(apiClientProvider).updateBaseUrl(serverUrl);

      debugPrint('[AppInitialization] API client initialized');

      // Small delay for splash screen visibility (optional)
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Success!
      state = const AppInitializationState.success();
      debugPrint('[AppInitialization] Initialization complete ✓');
    } on Exception catch (e, stackTrace) {
      debugPrint('[AppInitialization] Initialization failed: $e');
      debugPrint('[AppInitialization] Stack trace: $stackTrace');

      state = const AppInitializationState.error(
        'Failed to connect to Radio Browser servers. '
        'Please check your internet connection and try again.',
      );
    }
  }

  /// Retry initialization (called when user taps retry button)
  Future<void> retry() async {
    state = const AppInitializationState.loading();
    await _initialize();
  }
}
