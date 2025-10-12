import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tuneatlas/src/core/models/station.dart';

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
    _player.playerStateStream.listen((playerState) {
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
    });

    // Listen to errors from playback stream
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace st) {
        debugPrint('[RadioAudioHandler] Playback error: $e');
        debugPrint('[RadioAudioHandler] Stack trace: $st');

        // Set error state and stop loading
        playbackState.add(
          playbackState.value.copyWith(
            processingState: AudioProcessingState.error,
            playing: false,
          ),
        );
      },
    );
  }

  /// Play a radio station
  Future<void> playStation(Station station) async {
    try {
      debugPrint('[RadioAudioHandler] Playing: ${station.name}');
      _currentStation = station;

      // Update media item for notification with proper metadata
      mediaItem.add(
        MediaItem(
          id: station.stationUuid,
          title: station.name,
          artist: station.country.isNotEmpty ? station.country : 'Radio',
          album: 'Live Radio',
          artUri:
              station.favicon.isNotEmpty ? Uri.parse(station.favicon) : null,
          duration: Duration.zero, // Live stream = no duration
        ),
      );

      // Set audio source with timeout
      await _player.setUrl(station.url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Stream connection timeout - server not responding');
        },
      );

      // Start playback
      await _player.play();

      debugPrint('[RadioAudioHandler] Playback started');
    } catch (e) {
      debugPrint('[RadioAudioHandler] Error playing station: $e');

      // Set error state and ensure loading is cleared
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          playing: false,
        ),
      );

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
}
