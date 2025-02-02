import 'package:android_popular_git_repos/features/repository/data/models/repository_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class LocalDataSource {
  Future<void> cacheRepositories(List<RepositoryModel> repositories);
  Future<List<RepositoryModel>> getCachedRepositories();
}

class LocalDataSourceImpl implements LocalDataSource {
  static Database? _database;
// Singleton instance to ensure only one database connection
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'github_repos.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
  CREATE TABLE repositories(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  description TEXT,
  ownerName TEXT,
  ownerAvatarUrl TEXT,
  updatedAt TEXT
  
  )
  ''');
  }

  @override
  Future<void> cacheRepositories(List<RepositoryModel> repositories) async {
    // TODO: implement cacheRepositories
    final db = await database;
    //clear existing data before caching new data
    await db.delete('repositories');
    //insert each repository into the database
    for (final repository in repositories) {
      await db.insert('repositories', repository.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  @override
  Future<List<RepositoryModel>> getCachedRepositories() async {
    final db= await database;
    final result= await db.query('repositories');
    // Convert the raw data into RepositoryModel objects
    return result.map((json) => RepositoryModel.fromJson(json)).toList();

  }
}
