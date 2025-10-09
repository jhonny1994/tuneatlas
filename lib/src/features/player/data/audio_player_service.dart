import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuneatlas/src/src.dart' show Station;

/// Audio player service using just_audio
class AudioPlayerService {
  AudioPlayerService._() {
    _init();
  }

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

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
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  // Current values
  Station? get currentStation => _currentStationSubject.value;
  bool get isPlaying => _isPlayingSubject.value;
  bool get isLoading => _isLoadingSubject.value;
  bool get isStopped => _isStoppedSubject.value;
  String? get error => _errorSubject.value;

  void _init() {
    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      _isPlayingSubject.add(state.playing);
      _isLoadingSubject.add(
        state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering,
      );

      if (state.processingState == ProcessingState.completed) {
        _isStoppedSubject.add(true);
      }
    });

    // Listen to errors
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace st) {
        debugPrint('[AudioPlayerService] Playback error: $e');
        _errorSubject.add(e.toString());
        _isLoadingSubject.add(false);
      },
    );
  }

  /// Play a radio station
  Future<void> playStation(Station station) async {
    try {
      debugPrint('[AudioPlayerService] Playing station: ${station.name}');
      debugPrint('[AudioPlayerService] Stream URL: ${station.url}');

      _errorSubject.add(null);
      _isLoadingSubject.add(true);
      _isStoppedSubject.add(false);
      _currentStationSubject.add(station);

      // Set audio source
      await _player.setUrl(station.url);

      // Start playback
      await _player.play();

      debugPrint('[AudioPlayerService] Playback started successfully');
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error playing station: $e');
      _errorSubject.add('Failed to play station: $e');
      _isLoadingSubject.add(false);
      _currentStationSubject.add(null);
    }
  }

  /// Resume playback
  Future<void> play() async {
    try {
      await _player.play();
      _isStoppedSubject.add(false);
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error resuming: $e');
      _errorSubject.add('Failed to resume playback');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _player.pause();
    } on Exception catch (e) {
      debugPrint('[AudioPlayerService] Error pausing: $e');
    }
  }

  /// Stop playback and clear current station
  Future<void> stop() async {
    try {
      debugPrint('[AudioPlayerService] Stopping playback');
      await _player.stop();
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
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _player.dispose();
    await _currentStationSubject.close();
    await _isPlayingSubject.close();
    await _isLoadingSubject.close();
    await _isStoppedSubject.close();
    await _errorSubject.close();
  }
}
