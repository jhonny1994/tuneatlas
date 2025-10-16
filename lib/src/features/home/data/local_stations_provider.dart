import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'local_stations_provider.g.dart';

/// Manages paginated local stations with infinite scroll
@Riverpod(keepAlive: true)
class LocalStations extends _$LocalStations {
  late String _currentCountry;

  @override
  Future<LocalStationsState> build() async {
    // Load initial data
    return _loadInitial();
  }

  /// Load initial page (reset everything)
  Future<LocalStationsState> _loadInitial() async {
    try {
      // Get user's country
      final countryCode = await ref.watch(userCountryProvider.future);
      _currentCountry = countryCode;

      // Fetch first page
      final api = ref.read(radioBrowserApiProvider);
      final result = await api.getStationsByCountry(
        countryCode: countryCode,
        limit: AppConfig.pageSize,
      );

      return result.when(
        success: (stations) {
          return LocalStationsState(
            stations: stations,
            currentOffset: AppConfig.pageSize,
            hasMore: stations.length >= AppConfig.pageSize,
            isLoading: false,
          );
        },
        failure: (error) {
          return LocalStationsState(
            isLoading: false,
            error: error,
          );
        },
      );
    } on Exception {
      return const LocalStationsState(
        isLoading: false,
        error: 'Failed to load stations',
      );
    }
  }

  /// Load next page (pagination)
  Future<void> loadMore() async {
    // Don't load if already loading or no data
    if (!state.value!.canLoadMore) {
      return;
    }

    try {
      // Set loading state
      state = AsyncData(state.value!.copyWith(isLoadingMore: true));

      // Fetch next page
      final api = ref.read(radioBrowserApiProvider);
      final result = await api.getStationsByCountry(
        countryCode: _currentCountry,
        limit: AppConfig.pageSize,
        offset: state.value!.currentOffset,
      );

      result.when(
        success: (newStations) {
          // Append new stations to existing list
          final updatedStations = [...state.value!.stations, ...newStations];

          state = AsyncData(
            state.value!.copyWith(
              stations: updatedStations,
              currentOffset: state.value!.currentOffset + AppConfig.pageSize,
              hasMore: newStations.length >= AppConfig.pageSize,
              isLoadingMore: false,
            ),
          );
        },
        failure: (error) {
          // Keep existing data, just stop loading
          state = AsyncData(
            state.value!.copyWith(
              isLoadingMore: false,
              error: error,
            ),
          );
        },
      );
    } on Exception {
      state = AsyncData(
        state.value!.copyWith(
          isLoadingMore: false,
          error: 'Failed to load more stations',
        ),
      );
    }
  }

  /// Refresh (pull to refresh)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadInitial);
  }
}
