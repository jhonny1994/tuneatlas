import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'audio_state.freezed.dart';

/// Audio player state
@freezed
abstract class AudioState with _$AudioState {
  const factory AudioState({
    /// Currently playing station
    Station? currentStation,

    /// Is audio playing?
    @Default(false) bool isPlaying,

    /// Is audio loading/buffering?
    @Default(false) bool isLoading,

    /// Is audio stopped?
    @Default(true) bool isStopped,

    /// Error message
    String? error,

    /// Stream URL being played
    String? streamUrl,

    /// Audio position (for progress tracking)
    @Default(Duration.zero) Duration position,

    /// Audio duration (for live streams, this is usually zero)
    Duration? duration,

    /// Buffered position
    @Default(Duration.zero) Duration bufferedPosition,
  }) = _AudioState;

  const AudioState._();

  /// Check if a station is currently playing
  bool isPlayingStation(String stationUuid) {
    return isPlaying &&
        currentStation != null &&
        currentStation!.stationUuid == stationUuid;
  }

  /// Check if there's an active player (playing or paused)
  bool get hasActivePlayer => currentStation != null && !isStopped;
}
