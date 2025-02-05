import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final String _lastSyncKey = 'last_sync_time';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'git_repos.db');
    return await openDatabase(
      path,
      version: 2, // Increased version for new table
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE repositories(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        owner_login TEXT,
        owner_avatar_url TEXT,
        star_count INTEGER,
        last_updated TEXT,
        fork BOOLEAN,
        forks_count INTEGER,
        has_downloads BOOLEAN,
        language TEXT,
        license_key TEXT,
        license_name TEXT,
        visibility TEXT,
        topics TEXT,
        homepage TEXT,
        open_issues_count INTEGER,
        has_issues BOOLEAN,
        has_projects BOOLEAN,
        has_wiki BOOLEAN,
        has_discussions BOOLEAN
      )
    ''');

    await db.execute('''
      CREATE TABLE metadata(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE metadata(
          key TEXT PRIMARY KEY,
          value TEXT
        )
      ''');
    }
  }

  Future<DateTime?> getLastSyncTime() async {
    final db = await database;
    final result = await db.query(
      'metadata',
      where: 'key = ?',
      whereArgs: [_lastSyncKey],
    );

    if (result.isNotEmpty) {
      return DateTime.parse(result.first['value'] as String);
    }
    return null;
  }

  Future<void> updateLastSyncTime() async {
    final db = await database;
    await db.insert(
      'metadata',
      {
        'key': _lastSyncKey,
        'value': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> shouldFetchFromApi() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;

    final difference = DateTime.now().difference(lastSync);
    return difference.inHours >= 2;
  }

  Future<void> insertRepository(Map<String, dynamic> repository) async {
    final Database db = await database;
    await db.insert(
      'repositories',
      repository,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRepositories() async {
    final Database db = await database;
    return await db.query(
      'repositories',
      orderBy: 'star_count DESC',
    );
  }

  Future<void> clearRepositories() async {
    final Database db = await database;
    await db.delete('repositories');
  }
  // You may also want to add a refresh function to force update
  Future<void> forceRefresh() async {
    // Reset last sync time to null to force fetch
    final db = await database;
    await db.delete(
      'metadata',
      where: 'key = ?',
      whereArgs: [_lastSyncKey],
    );
    // Then call getAndroidRepositories()


  }
}