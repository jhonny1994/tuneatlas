import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuneatlas/src/src.dart';

part 'audio_provider.g.dart';

/// Audio player provider
@Riverpod(keepAlive: true)
class AudioPlayer extends _$AudioPlayer {
  late final AudioPlayerService _service;

  @override
  Stream<AudioState> build() {
    _service = AudioPlayerService.instance;

    // Inject RadioBrowserApi for click tracking
    final api = ref.read(radioBrowserApiProvider);
    _service.api = api;

    // Combine all streams into a single AudioState stream
    return _service.currentStationStream.switchMap((station) {
      return _service.isPlayingStream.switchMap((isPlaying) {
        return _service.isLoadingStream.switchMap((isLoading) {
          return _service.isStoppedStream.switchMap((isStopped) {
            return _service.errorStream.switchMap((error) {
              return _service.positionStream.map((position) {
                return AudioState(
                  currentStation: station,
                  isPlaying: isPlaying,
                  isLoading: isLoading,
                  isStopped: isStopped,
                  error: error,
                  position: position,
                );
              });
            });
          });
        });
      });
    });
  }

  /// Play a station
  Future<void> playStation(Station station) async {
    await _service.playStation(station);
  }

  /// Play/resume
  Future<void> play() async {
    await _service.play();
  }

  /// Pause
  Future<void> pause() async {
    await _service.pause();
  }

  /// Stop and clear
  Future<void> stop() async {
    await _service.stop();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    await _service.togglePlayPause();
  }

  /// Set volume
  Future<void> setVolume(double volume) async {
    await _service.setVolume(volume);
  }
}
