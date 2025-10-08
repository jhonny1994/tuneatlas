import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuneatlas/src/core/models/station.dart';

part 'search_state.freezed.dart';

/// State for search functionality
@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    /// Current search query
    @Default('') String query,

    /// Search results (accumulated across pages)
    @Default([]) List<Station> results,

    /// Current offset for pagination
    @Default(0) int currentOffset,

    /// Are there more results to load?
    @Default(true) bool hasMore,

    /// Is initial search loading?
    @Default(false) bool isLoading,

    /// Is loading more results (pagination)?
    @Default(false) bool isLoadingMore,

    /// Error message
    String? error,

    /// Has user performed a search?
    @Default(false) bool hasSearched,
  }) = _SearchState;

  const SearchState._();

  /// Check if we have results
  bool get hasResults => results.isNotEmpty;

  /// Can load more results?
  bool get canLoadMore => hasMore && !isLoadingMore && !isLoading;

  /// Show empty state (searched but no results)
  bool get showEmptyState => hasSearched && !isLoading && results.isEmpty;
}
