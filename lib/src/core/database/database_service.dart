import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

/// Sembast database service
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;
  Future<Database>? _initFuture;

  /// Get database instance
  Future<Database> get database async {
    // If already initialized, return it
    if (_database != null) return _database!;

    // If initialization is in progress, wait for it
    if (_initFuture != null) return _initFuture!;

    // Start initialization
    _initFuture = _initDatabase();
    _database = await _initFuture;

    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      await appDir.create(recursive: true);
      final dbPath = join(appDir.path, 'tuneatlas.db');

      final database = await databaseFactoryIo.openDatabase(dbPath);

      return database;
    } catch (e) {
      _initFuture = null; // Reset on error so it can be retried
      rethrow;
    }
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initFuture = null;
    }
  }
}
