import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_initialization_state.freezed.dart';

/// Represents the state of app initialization
@freezed
class AppInitializationState with _$AppInitializationState {
  /// Loading state - discovering server
  const factory AppInitializationState.loading() = _Loading;

  /// Success state - ready to use app
  const factory AppInitializationState.success() = _Success;

  /// Error state - initialization failed
  const factory AppInitializationState.error(String message) = _Error;
}
