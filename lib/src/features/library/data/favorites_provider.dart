import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'favorites_provider.g.dart';

/// Provider for favorite stations
@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  @override
  Future<List<Station>> build() async {
    return _loadFavorites();
  }

  Future<List<Station>> _loadFavorites() async {
    try {
      final favorites = await FavoritesService.instance.getAllFavorites();
      return favorites;
    } on Exception {
      return [];
    }
  }

  /// Add station to favorites
  Future<void> addFavorite(Station station) async {
    try {
      await FavoritesService.instance.addFavorite(station);

      // Refresh state
      state = await AsyncValue.guard(_loadFavorites);
    } on Exception {
      // Handle error if needed
    }
  }

  /// Remove station from favorites
  Future<void> removeFavorite(String stationUuid) async {
    try {
      await FavoritesService.instance.removeFavorite(stationUuid);

      // Refresh state
      state = await AsyncValue.guard(_loadFavorites);
    } on Exception {
      // Handle error if needed
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Station station) async {
    final isFav = await FavoritesService.instance.isFavorite(
      station.stationUuid,
    );

    if (isFav) {
      await removeFavorite(station.stationUuid);
    } else {
      await addFavorite(station);
    }
  }

  /// Check if station is favorite
  Future<bool> isFavorite(String stationUuid) async {
    return FavoritesService.instance.isFavorite(stationUuid);
  }

  /// Refresh favorites
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFavorites);
  }
}
