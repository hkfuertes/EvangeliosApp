import 'dart:async';

import '../Model/Comment.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingsHelper {
  static final String databaseName = "settings.db";
  static final SettingsHelper _instance = SettingsHelper._();
  static Database _database;

  SettingsHelper._();

  factory SettingsHelper() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    String dbPath = join(await getDatabasesPath(), databaseName);
    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE Settings(
      key TEXT PRIMARY KEY,
      value TEXT)
  ''');

    print("Databases created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    db.execute("DROP TABLE Settings;");

    this._onCreate(db, newVersion);
  }

  /*
   * Instance Related Functions
   */
  Future<int> setValue(String key, dynamic value) async {
    var client = await db;
    return client.insert('Settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getValue(String key) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('Settings', where: 'key = ?', whereArgs: [key]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return maps.first['value'];
    }
    return null;
  }
}
