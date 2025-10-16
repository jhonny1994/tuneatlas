import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'filtered_stations_provider.g.dart';

/// Provider for filtered stations (by country, language, or tag)
@riverpod
class FilteredStations extends _$FilteredStations {
  @override
  Future<FilteredStationsState> build({
    required String filterType,
    required String filterValue,
  }) async {
    return _loadInitial(filterType, filterValue);
  }

  Future<FilteredStationsState> _loadInitial(
    String filterType,
    String filterValue,
  ) async {
    try {
      final api = ref.read(radioBrowserApiProvider);
      Result<List<Station>> result;

      // Call appropriate API method based on filter type
      switch (filterType) {
        case 'country':
          result = await api.getStationsByCountry(
            countryCode: filterValue,
            limit: AppConfig.pageSize,
          );
        case 'language':
          result = await api.getStationsByLanguage(
            language: filterValue,
            limit: AppConfig.pageSize,
          );
        case 'tag':
          result = await api.getStationsByTag(
            tag: filterValue,
            limit: AppConfig.pageSize,
          );
        default:
          throw Exception('Unknown filter type: $filterType');
      }

      return result.when(
        success: (stations) {
          return FilteredStationsState(
            filterType: filterType,
            filterValue: filterValue,
            stations: stations,
            currentOffset: AppConfig.pageSize,
            hasMore: stations.length >= AppConfig.pageSize,
            isLoading: false,
          );
        },
        failure: (error) {
          return FilteredStationsState(
            filterType: filterType,
            filterValue: filterValue,
            isLoading: false,
            error: error,
          );
        },
      );
    } on Exception {
      return FilteredStationsState(
        filterType: filterType,
        filterValue: filterValue,
        isLoading: false,
        error: 'Failed to load stations',
      );
    }
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || !currentState.canLoadMore) return;

    try {
      state = AsyncData(currentState.copyWith(isLoadingMore: true));

      final api = ref.read(radioBrowserApiProvider);
      Result<List<Station>> result;

      switch (currentState.filterType) {
        case 'country':
          result = await api.getStationsByCountry(
            countryCode: currentState.filterValue,
            limit: AppConfig.pageSize,
            offset: currentState.currentOffset,
          );
        case 'language':
          result = await api.getStationsByLanguage(
            language: currentState.filterValue,
            limit: AppConfig.pageSize,
            offset: currentState.currentOffset,
          );
        case 'tag':
          result = await api.getStationsByTag(
            tag: currentState.filterValue,
            limit: AppConfig.pageSize,
            offset: currentState.currentOffset,
          );
        default:
          throw Exception('Unknown filter type: ${currentState.filterType}');
      }

      result.when(
        success: (newStations) {
          final updatedStations = [...currentState.stations, ...newStations];
          state = AsyncData(
            currentState.copyWith(
              stations: updatedStations,
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
          error: 'Failed to load more',
        ),
      );
    }
  }
}
