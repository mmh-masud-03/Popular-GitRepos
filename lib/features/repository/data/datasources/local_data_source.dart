import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final path = join(await getDatabasesPath(), 'git_repositories.db');

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
      id INTEGER PRIMARY KEY ,
      name TEXT,
      description TEXT,
      ownerName TEXT,
      ownerAvatarUrl TEXT,
      forksCount INTEGER,
      stargazersCount INTEGER,
      language TEXT,
      licenseName TEXT,
      openIssuesCount INTEGER,
      homepage TEXT,
      updatedAt INTEGER
      )
    ''');
  }

  @override
  Future<void> cacheRepositories(List<RepositoryModel> repositories) async {
    final db = await database;

    // Start a transaction to ensure atomic operation
    await db.transaction((txn) async {
      // Completely clear the existing table
      await txn.delete('repositories');

      // Batch insert to improve performance
      final batch = txn.batch();
      for (final repo in repositories) {
        batch.insert(
          'repositories',
          repo.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);
      print('DEBUG: Cached ${repositories.length} repositories-----------------------------------');
    });
  }

  @override
  Future<List<RepositoryModel>> getCachedRepositories() async {
    final db = await database;
    final result = await db.query('repositories');
    print('DEBUG: Total Repositories in Database: ${result.length}');
    for (var repo in result) {
      print('Repo Name: ${repo['name']}');
      print('Owner: ${repo['ownerName']}');
      print('Stars: ${repo['stargazersCount']}');
      print('---');
    }
    print('Got from cache: ${result.length} repositories');
    // Convert the raw data into RepositoryModel objects
    return result.map((json) => RepositoryModel.fromJson(json)).toList();
  }
  @override
  Future<bool> shouldUpdateData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateMillis = prefs.getInt(lastUpdateKey) ?? 0;
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    final now = DateTime.now();
 print('DEBUG: Last Update Time: $lastUpdate');
    return now.difference(lastUpdate).inMinutes > 1;
  }
  @override
  Future<void> updateLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
}