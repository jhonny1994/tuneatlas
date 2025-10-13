import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tuneatlas/src/core/core.dart';

/// Background audio handler with modern notification styling
class RadioAudioHandler extends BaseAudioHandler {
  RadioAudioHandler() {
    _init();
  }
  final AudioPlayer _player = AudioPlayer();
  Station? _currentStation;

  void _init() {
    // Initialize playback state with modern controls
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.stop,
          MediaControl.play,
        ],
        androidCompactActionIndices: const [
          0,
          1,
        ], // Show stop & play in compact view
      ),
    );

    // Listen to player state changes
    _player.playerStateStream.listen(
      (playerState) {
        final isPlaying = playerState.playing;
        final processingState = const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState]!;

        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.stop,
              if (isPlaying) MediaControl.pause else MediaControl.play,
            ],
            systemActions: const {
              MediaAction.stop,
            },
            androidCompactActionIndices: const [0, 1], // Stop + Play/Pause
            processingState: processingState,
            playing: isPlaying,
          ),
        );
      },
      onError: (Object e, StackTrace st) {
        debugPrint('[RadioAudioHandler] Player state error: $e');
        debugPrint('[RadioAudioHandler] Stack trace: $st');
        _handleError();
      },
    );

    // Listen to errors from playback stream
    _player.playbackEventStream.listen(
      (event) {
        // Monitor playback events
      },
      onError: (Object e, StackTrace st) {
        debugPrint('[RadioAudioHandler] Playback event error: $e');
        debugPrint('[RadioAudioHandler] Stack trace: $st');
        _handleError();
      },
    );
  }

  /// Handle error state consistently
  void _handleError() {
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ),
    );
  }

  /// Play a radio station
  Future<void> playStation(Station station) async {
    try {
      debugPrint('[RadioAudioHandler] Playing: ${station.name}');
      _currentStation = station;

      // CRITICAL: Reset to clean loading state (clears any previous error)
      playbackState.add(
        PlaybackState(
          processingState: AudioProcessingState.loading,
          controls: [],
        ),
      );

      // Update media item for notification with proper metadata
      mediaItem.add(
        MediaItem(
          id: station.stationUuid,
          title: station.name,
          artist: station.country.isNotEmpty ? station.country : 'Radio',
          album: 'Live Radio',
          artUri: _parseArtUri(station.favicon),
          duration: Duration.zero, // Live stream = no duration
        ),
      );

      // Set audio source with timeout
      await _player.setUrl(station.url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
            'Stream connection timeout - server not responding',
          );
        },
      );

      // Start playback
      await _player.play();

      debugPrint('[RadioAudioHandler] Playback started');
    } catch (e) {
      debugPrint('[RadioAudioHandler] Error playing station: $e');
      _handleError();
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    debugPrint('[RadioAudioHandler] Play');
    await _player.play();
  }

  @override
  Future<void> pause() async {
    debugPrint('[RadioAudioHandler] Pause');
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    debugPrint('[RadioAudioHandler] Stop');
    await _player.stop();
    _currentStation = null;

    // Clear media item
    mediaItem.add(null);

    // Reset playback state
    playbackState.add(
      PlaybackState(
        controls: [],
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    // Not applicable for live radio
  }

  Station? get currentStation => _currentStation;
  bool get isPlaying => _player.playing;
  bool get isLoading =>
      _player.processingState == ProcessingState.loading ||
      _player.processingState == ProcessingState.buffering;

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
    }
  }

  /// Safely parse favicon URL to Uri
  /// Returns null if URL is empty, invalid, or null
  Uri? _parseArtUri(String? favicon) {
    if (favicon == null || favicon.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.parse(favicon);
      // Validate that the URI has a scheme and host
      if (uri.hasScheme && uri.hasAuthority) {
        return uri;
      }
      debugPrint(
        '[RadioAudioHandler] Invalid artUri: $favicon (missing scheme or host)',
      );
      return null;
    } on Exception catch (e) {
      debugPrint('[RadioAudioHandler] Failed to parse artUri: $favicon - $e');
      return null;
    }
  }
}
