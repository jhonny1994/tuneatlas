import 'package:sembast/sembast.dart';
import 'package:tuneatlas/src/src.dart';

/// Service for managing favorite stations
class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  // Store name
  static const String _storeName = 'favorites';

  // Get store
  final StoreRef<int, Map<String, Object?>> _store = intMapStoreFactory.store(
    _storeName,
  );

  /// Add station to favorites
  Future<void> addFavorite(Station station) async {
    try {
      final db = await DatabaseService.instance.database;

      // Check if already exists
      final existing = await _store.findFirst(
        db,
        finder: Finder(
          filter: Filter.equals('stationuuid', station.stationUuid),
        ),
      );

      if (existing != null) {
        return;
      }

      // Add to favorites
      await _store.add(db, station.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Remove station from favorites
  Future<void> removeFavorite(String stationUuid) async {
    try {
      final db = await DatabaseService.instance.database;

      await _store.delete(
        db,
        finder: Finder(
          filter: Filter.equals('stationuuid', stationUuid),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Check if station is favorite
  Future<bool> isFavorite(String stationUuid) async {
    try {
      final db = await DatabaseService.instance.database;

      final record = await _store.findFirst(
        db,
        finder: Finder(
          filter: Filter.equals('stationuuid', stationUuid),
        ),
      );

      return record != null;
    } on Exception {
      return false;
    }
  }

  /// Get all favorites
  Future<List<Station>> getAllFavorites() async {
    try {
      final db = await DatabaseService.instance.database;

      final records = await _store.find(db);

      final stations = records
          .map((record) => Station.fromJson(record.value))
          .toList();

      return stations;
    } on Exception {
      return [];
    }
  }

  /// Get favorites count
  Future<int> getFavoritesCount() async {
    try {
      final db = await DatabaseService.instance.database;
      return await _store.count(db);
    } on Exception {
      return 0;
    }
  }

  /// Clear all favorites
  Future<void> clearAll() async {
    try {
      final db = await DatabaseService.instance.database;
      await _store.delete(db);
    } catch (e) {
      rethrow;
    }
  }

  /// Listen to favorites changes (stream)
  Stream<List<Station>> watchFavorites() async* {
    final db = await DatabaseService.instance.database;

    yield* _store.query().onSnapshots(db).map((snapshots) {
      return snapshots
          .map((snapshot) => Station.fromJson(snapshot.value))
          .toList();
    });
  }
}
