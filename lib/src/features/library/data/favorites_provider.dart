import 'package:flutter/foundation.dart';
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
      debugPrint('[Favorites] Loading favorites...');
      final favorites = await FavoritesService.instance.getAllFavorites();
      debugPrint('[Favorites] Loaded ${favorites.length} favorites');
      return favorites;
    } on Exception catch (e) {
      debugPrint('[Favorites] Error loading favorites: $e');
      return [];
    }
  }

  /// Add station to favorites
  Future<void> addFavorite(Station station) async {
    try {
      await FavoritesService.instance.addFavorite(station);

      // Refresh state
      state = await AsyncValue.guard(_loadFavorites);
    } on Exception catch (e) {
      debugPrint('[Favorites] Error adding favorite: $e');
    }
  }

  /// Remove station from favorites
  Future<void> removeFavorite(String stationUuid) async {
    try {
      await FavoritesService.instance.removeFavorite(stationUuid);

      // Refresh state
      state = await AsyncValue.guard(_loadFavorites);
    } on Exception catch (e) {
      debugPrint('[Favorites] Error removing favorite: $e');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Station station) async {
    final isFav =
        await FavoritesService.instance.isFavorite(station.stationUuid);

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
