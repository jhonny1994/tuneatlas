import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'search_provider.g.dart';

/// Manages search functionality with pagination
@riverpod
class Search extends _$Search {
  @override
  Future<SearchState> build() async {
    return const SearchState();
  }

  /// Search stations by name
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData(SearchState());
      return;
    }

    try {
      debugPrint('[Search] Searching for: $query');

      state = AsyncData(
        SearchState(
          query: query,
          isLoading: true,
          hasSearched: true,
        ),
      );

      final api = ref.read(radioBrowserApiProvider);
      final result = await api.searchStations(
        query: query,
        limit: AppConfig.pageSize,
      );

      result.when(
        success: (stations) {
          debugPrint('[Search] Found ${stations.length} stations');

          state = AsyncData(
            SearchState(
              query: query,
              results: stations,
              currentOffset: AppConfig.pageSize,
              hasMore: stations.length >= AppConfig.pageSize,
              hasSearched: true,
            ),
          );
        },
        failure: (error) {
          debugPrint('[Search] Error: $error');
          state = AsyncData(
            SearchState(
              query: query,
              error: error,
              hasSearched: true,
            ),
          );
        },
      );
    } on Exception catch (e) {
      debugPrint('[Search] Unexpected error: $e');
      state = AsyncData(
        SearchState(
          query: query,
          error: 'Search failed',
          hasSearched: true,
        ),
      );
    }
  }

  /// Load more results (pagination)
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || !currentState.canLoadMore) {
      debugPrint('[Search] Cannot load more');
      return;
    }

    try {
      debugPrint(
        '[Search] Loading more from offset ${currentState.currentOffset}',
      );

      state = AsyncData(currentState.copyWith(isLoadingMore: true));

      final api = ref.read(radioBrowserApiProvider);
      final result = await api.searchStations(
        query: currentState.query,
        limit: AppConfig.pageSize,
        offset: currentState.currentOffset,
      );

      result.when(
        success: (newStations) {
          debugPrint('[Search] Loaded ${newStations.length} more stations');

          final updatedStations = [...currentState.results, ...newStations];

          state = AsyncData(
            currentState.copyWith(
              results: updatedStations,
              currentOffset: currentState.currentOffset + AppConfig.pageSize,
              hasMore: newStations.length >= AppConfig.pageSize,
              isLoadingMore: false,
            ),
          );
        },
        failure: (error) {
          debugPrint('[Search] Pagination error: $error');
          state = AsyncData(
            currentState.copyWith(
              isLoadingMore: false,
              error: error,
            ),
          );
        },
      );
    } on Exception catch (e) {
      debugPrint('[Search] Pagination unexpected error: $e');
      state = AsyncData(
        currentState.copyWith(
          isLoadingMore: false,
          error: 'Failed to load more results',
        ),
      );
    }
  }

  /// Clear search
  void clear() {
    state = const AsyncData(SearchState());
  }
}
