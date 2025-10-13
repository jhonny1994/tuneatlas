import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

/// Network connectivity state
enum NetworkStatus {
  online,
  offline,
}

/// Monitors network connectivity changes
@Riverpod(keepAlive: true)
class NetworkMonitor extends _$NetworkMonitor {
  late final Connectivity _connectivity;

  @override
  Stream<NetworkStatus> build() {
    _connectivity = Connectivity();

    // Listen to connectivity changes
    return _connectivity.onConnectivityChanged.asyncMap((results) async {
      // results is a List<ConnectivityResult>
      final isConnected = results.any(
        (result) => result != ConnectivityResult.none,
      );

      final status = isConnected ? NetworkStatus.online : NetworkStatus.offline;

      debugPrint('[NetworkMonitor] Status: $status (${results.join(', ')})');

      return status;
    });
  }

  /// Check current connectivity status synchronously
  Future<NetworkStatus> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final isConnected = results.any(
      (result) => result != ConnectivityResult.none,
    );
    return isConnected ? NetworkStatus.online : NetworkStatus.offline;
  }

  /// Check if currently online
  Future<bool> isOnline() async {
    final status = await checkConnectivity();
    return status == NetworkStatus.online;
  }
}
