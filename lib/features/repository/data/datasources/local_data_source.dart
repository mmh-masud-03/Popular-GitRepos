import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/repository_model.dart';

abstract class LocalDataSource {
  Future<void> cacheRepositories(List<RepositoryModel> repositories);
  Future<List<RepositoryModel>> getCachedRepositories();
  Future<bool> shouldUpdateData();
  Future<void> updateLastUpdateTime();
}

class LocalDataSourceImpl implements LocalDataSource {
  static Database? _database;
  static const lastUpdateKey = 'last_update_time';

  // Singleton instance to ensure only one database connection
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'github_repos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the table when the database is first created
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE repositories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        ownerName TEXT,
        ownerAvatarUrl TEXT,
        ownerId TEXT,
        updatedAt TEXT
      )
    ''');
  }

  @override
  Future<void> cacheRepositories(List<RepositoryModel> repositories) async {
    final db = await database;
    // Clear existing data before inserting new data
    await db.delete('repositories');

    // Insert each repository into the database
    for (final repo in repositories) {
      await db.insert(
        'repositories',
        repo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<List<RepositoryModel>> getCachedRepositories() async {
    final db = await database;
    final result = await db.query('repositories');

    // Convert the raw data into RepositoryModel objects
    return result.map((json) => RepositoryModel.fromJson(json)).toList();
  }
  @override
  Future<bool> shouldUpdateData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateMillis = prefs.getInt(lastUpdateKey) ?? 0;
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    final now = DateTime.now();

    return now.difference(lastUpdate).inMinutes > 1;
  }
  @override
  Future<void> updateLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
}