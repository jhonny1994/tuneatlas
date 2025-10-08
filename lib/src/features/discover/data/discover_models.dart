import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuneatlas/src/core/models/station.dart';

part 'discover_models.freezed.dart';

/// Category type for discovery
enum DiscoverCategory {
  countries,
  languages,
  tags,
}

/// State for filtered stations (after selecting a category item)
@freezed
abstract class FilteredStationsState with _$FilteredStationsState {
  const factory FilteredStationsState({
    /// Filter type (country/language/tag)
    required String filterType,

    /// Filter value (e.g., "US", "English", "pop")
    required String filterValue,

    /// Filtered stations
    @Default([]) List<Station> stations,

    /// Pagination offset
    @Default(0) int currentOffset,

    /// Has more results?
    @Default(true) bool hasMore,

    /// Loading state
    @Default(true) bool isLoading,

    /// Loading more (pagination)
    @Default(false) bool isLoadingMore,

    /// Error message
    String? error,
  }) = _FilteredStationsState;

  const FilteredStationsState._();

  bool get hasStations => stations.isNotEmpty;
  bool get canLoadMore => hasMore && !isLoadingMore && !isLoading;
}
