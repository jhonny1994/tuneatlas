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
          state = AsyncData(
            SearchState(
              query: query,
              error: error,
              hasSearched: true,
            ),
          );
        },
      );
    } on Exception {
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
      return;
    }

    try {
      state = AsyncData(currentState.copyWith(isLoadingMore: true));

      final api = ref.read(radioBrowserApiProvider);
      final result = await api.searchStations(
        query: currentState.query,
        limit: AppConfig.pageSize,
        offset: currentState.currentOffset,
      );

      result.when(
        success: (newStations) {
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
          state = AsyncData(
            currentState.copyWith(
              isLoadingMore: false,
              error: error,
            ),
          );
        },
      );
    } on Exception {
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
