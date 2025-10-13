import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'network_reconnect_handler.g.dart';

/// Handles automatic reconnection when network comes back online
@Riverpod(keepAlive: true)
class NetworkReconnectHandler extends _$NetworkReconnectHandler {
  Station? _lastStation;
  bool _wasPlayingBeforeDisconnect = false;

  @override
  Future<void> build() async {
    // Listen to network status changes
    ref
      ..listen<AsyncValue<NetworkStatus>>(
        networkMonitorProvider,
        _handleNetworkChange,
      )

      // Listen to current audio state to track what was playing
      ..listen<AsyncValue<AudioState>>(
        audioPlayerProvider,
        (previous, next) {
          next.whenData((state) {
            if (state.currentStation != null && state.isPlaying) {
              _lastStation = state.currentStation;
              _wasPlayingBeforeDisconnect = true;
            }
            if (state.isStopped) {
              _lastStation = null;
              _wasPlayingBeforeDisconnect = false;
            }
          });
        },
      );
  }

  Future<void> _handleNetworkChange(
    AsyncValue<NetworkStatus>? previous,
    AsyncValue<NetworkStatus> next,
  ) async {
    final previousStatus = previous?.whenOrNull(data: (status) => status);
    final currentStatus = next.whenOrNull(data: (status) => status);

    // Check if we just came back online
    if (previousStatus == NetworkStatus.offline &&
        currentStatus == NetworkStatus.online) {
      debugPrint(
        '[NetworkReconnectHandler] Back online - attempting reconnect',
      );
      await _attemptReconnect();
    }

    // Check if we just went offline
    if (previousStatus == NetworkStatus.online &&
        currentStatus == NetworkStatus.offline) {
      debugPrint('[NetworkReconnectHandler] Lost connection');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    ref.read(audioPlayerProvider).whenData((currentState) {
      if (currentState.isPlaying) {
        _wasPlayingBeforeDisconnect = true;
        _lastStation = currentState.currentStation;
        debugPrint(
          '[NetworkReconnectHandler] Saved state: ${_lastStation?.name}',
        );
      }
    });
  }

  Future<void> _attemptReconnect() async {
    // Only reconnect if we had a station playing before disconnect
    if (!_wasPlayingBeforeDisconnect || _lastStation == null) {
      debugPrint('[NetworkReconnectHandler] No station to reconnect');
      return;
    }

    // Wait a bit to ensure network is stable
    await Future<void>.delayed(const Duration(seconds: 2));

    // Check if network is still online
    final isOnline = await ref.read(networkMonitorProvider.notifier).isOnline();
    if (!isOnline) {
      debugPrint('[NetworkReconnectHandler] Network not stable, aborting');
      return;
    }

    // Check if user hasn't started playing something else
    final audioStateAsync = ref.read(audioPlayerProvider);
    final shouldAbort = audioStateAsync.whenOrNull(
      data: (currentState) =>
          currentState.currentStation?.stationUuid != _lastStation?.stationUuid,
    );

    if (shouldAbort ?? false) {
      debugPrint('[NetworkReconnectHandler] User changed station, aborting');
      return;
    }

    // Attempt to reconnect
    try {
      debugPrint(
        '[NetworkReconnectHandler] Reconnecting to ${_lastStation!.name}',
      );
      await ref.read(audioPlayerProvider.notifier).playStation(_lastStation!);
      _wasPlayingBeforeDisconnect = false;
    } on Exception catch (e) {
      debugPrint('[NetworkReconnectHandler] Reconnect failed: $e');
    }
  }

  /// Manually trigger reconnect (for user-initiated retry)
  Future<void> manualReconnect() async {
    ref.read(audioPlayerProvider).whenData((currentState) async {
      if (currentState.currentStation != null) {
        await ref
            .read(audioPlayerProvider.notifier)
            .playStation(currentState.currentStation!);
      }
    });
  }
}
