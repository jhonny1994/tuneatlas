import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuneatlas/src/core/models/station.dart';

part 'local_stations_state.freezed.dart';

/// State for paginated local stations
@freezed
abstract class LocalStationsState with _$LocalStationsState {
  const factory LocalStationsState({
    /// All loaded stations (accumulated across pages)
    @Default([]) List<Station> stations,

    /// Current offset for next page (0, 50, 100...)
    @Default(0) int currentOffset,

    /// Are there more stations to load?
    @Default(true) bool hasMore,

    /// Loading state for initial load
    @Default(true) bool isLoading,

    /// Loading state for pagination (load more)
    @Default(false) bool isLoadingMore,

    /// Error message (null if no error)
    String? error,
  }) = _LocalStationsState;

  const LocalStationsState._();

  /// Check if we have any stations loaded
  bool get hasStations => stations.isNotEmpty;

  /// Check if we can load more (not already loading and has more)
  bool get canLoadMore => hasMore && !isLoadingMore && !isLoading;
}
