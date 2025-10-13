import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuneatlas/src/src.dart';

/// Audio player service using audio_service for background playback
class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayerService instance = AudioPlayerService._();

  RadioAudioHandler? _handler;
  RadioBrowserApi? api;
  bool _initialized = false;

  // State streams
  final _currentStationSubject = BehaviorSubject<Station?>.seeded(null);
  final _isPlayingSubject = BehaviorSubject<bool>.seeded(false);
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _isStoppedSubject = BehaviorSubject<bool>.seeded(true);
  final _errorSubject = BehaviorSubject<String?>.seeded(null);

  // Public streams
  Stream<Station?> get currentStationStream => _currentStationSubject.stream;
  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  Stream<bool> get isStoppedStream => _isStoppedSubject.stream;
  Stream<String?> get errorStream => _errorSubject.stream;
  Stream<Duration> get positionStream => Stream.value(Duration.zero);
  Stream<Duration?> get durationStream => Stream.value(null);
  Stream<Duration> get bufferedPositionStream => Stream.value(Duration.zero);

  // Current values
  Station? get currentStation => _currentStationSubject.value;
  bool get isPlaying => _isPlayingSubject.value;
  bool get isLoading => _isLoadingSubject.value;
  bool get isStopped => _isStoppedSubject.value;
  String? get error => _errorSubject.value;

  /// Initialize audio service
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    try {
      _handler = await AudioService.init(
        builder: RadioAudioHandler.new,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.carbodex.tuneatlas.audio',
          androidNotificationChannelName: 'TuneAtlas',
          androidNotificationOngoing: true,
          androidShowNotificationBadge: true,
        ),
      );

      // Listen to playback state
      _handler!.playbackState.listen((state) {
        _isPlayingSubject.add(state.playing);

        final isLoading =
            state.processingState == AudioProcessingState.loading ||
                state.processingState == AudioProcessingState.buffering;
        final isError = state.processingState == AudioProcessingState.error;

        _isLoadingSubject.add(isLoading);
        _isStoppedSubject.add(
          state.processingState == AudioProcessingState.idle,
        );

        // Clear loading and set error state when error occurs
        if (isError && isLoading) {
          _isLoadingSubject.add(false);
        }
      });

      _initialized = true;
      debugPrint('[AudioPlayerService] Initialized successfully');
    } catch (e) {
      debugPrint('[AudioPlayerService] Initialization failed: $e');
      rethrow;
    }
  }

  /// Play a radio station
  Future<void> playStation(Station station) async {
    try {
      await _ensureInitialized();

      debugPrint('[AudioPlayerService] Playing station: ${station.name}');
      debugPrint('[AudioPlayerService] Stream URL: ${station.url}');

      // CRITICAL: Clear error state BEFORE attempting new playback
      // This prevents stale errors from previous stations
      _errorSubject.add(null);

      // Set loading state
      _isLoadingSubject.add(true);
      _isStoppedSubject.add(false);
      _isPlayingSubject.add(false);

      // Update current station
      _currentStationSubject.add(station);

      // Add timeout for station playback
      await _handler!.playStation(station).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException(
            'errorFailedToConnect',
          );
        },
      );

      // Success - clear error state
      _errorSubject.add(null);
      debugPrint('[AudioPlayerService] Playback started successfully');

      // Track station click for Radio Browser API (async, don't await)
      await _trackStationClick(station.stationUuid);
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error playing station: $e');

      // Format user-friendly error message (keys for AudioErrorMapper)
      var errorMessage = 'errorFailedToPlay';
      if (e is TimeoutException || e.toString().contains('timeout')) {
        errorMessage = 'errorConnectionTimeout';
      } else if (e.toString().contains('404')) {
        errorMessage = 'errorStreamNotFound';
      } else if (e.toString().contains('403') || e.toString().contains('401')) {
        errorMessage = 'errorAccessDenied';
      } else if (e.toString().contains('network') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'errorNetworkIssue';
      } else if (e.toString().contains('format')) {
        errorMessage = 'errorUnsupportedFormat';
      }

      // CRITICAL: Only set error state ONCE (not multiple times)
      // Update all states properly on error
      if (_errorSubject.value != errorMessage) {
        _errorSubject.add(errorMessage);
        debugPrint('[AudioPlayerService] Error state set: $errorMessage');
      }
      _isLoadingSubject.add(false);
      _isPlayingSubject.add(false);
      _isStoppedSubject.add(true);
      // Keep station for retry attempts
      // Don't clear station: _currentStationSubject.add(null);
    }
  }

  /// Resume playback
  Future<void> play() async {
    try {
      await _ensureInitialized();
      await _handler!.play();
      _isStoppedSubject.add(false);
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error resuming: $e');
      _errorSubject.add('errorFailedToResume');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _ensureInitialized();
      await _handler!.pause();
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error pausing: $e');
    }
  }

  /// Stop playback and clear current station
  Future<void> stop() async {
    try {
      debugPrint('[AudioPlayerService] Stopping playback');
      await _ensureInitialized();
      await _handler!.stop();
      _currentStationSubject.add(null);
      _isStoppedSubject.add(true);
      _errorSubject.add(null);
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error stopping: $e');
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    // Volume control through system volume
    debugPrint('[AudioPlayerService] Volume control via system');
  }

  /// Dispose resources
  Future<void> dispose() async {
    if (_handler != null) {
      await _handler!.customAction('dispose');
    }
    await _currentStationSubject.close();
    await _isPlayingSubject.close();
    await _isLoadingSubject.close();
    await _isStoppedSubject.close();
    await _errorSubject.close();
  }

  /// Track station click for Radio Browser API
  /// Runs asynchronously without blocking playback
  Future<void> _trackStationClick(String stationUuid) async {
    if (api == null) {
      debugPrint(
        '[AudioPlayerService] Cannot track click - API not initialized',
      );
      return;
    }

    // Run async without awaiting (fire and forget)
    await api!.trackStationClick(stationUuid).then((result) {
      result.when(
        success: (_) {
          debugPrint('[AudioPlayerService] Station click tracked');
        },
        failure: (error) {
          debugPrint('[AudioPlayerService] Click tracking failed: $error');
        },
      );
    });
  }
}
