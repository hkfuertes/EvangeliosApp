import 'dart:async';

import '../Model/Comment.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final String databaseName = "lecturas.db";
  static final DBHelper _instance = DBHelper._();
  static Database _database;

  DBHelper._();

  factory DBHelper() {
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
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE Comments(
      date TEXT PRIMARY KEY,
      comment TEXT)
  ''');

    print("Databases created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    db.execute("DROP TABLE Comment;");

    this._onCreate(db, newVersion);
  }

  /*
   * Instance Related Functions
   */
  Future<int> addComment(Comment comment) async {
    var client = await db;
    return client.insert('Comments', comment.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Comment> fetchComment(DateTime date) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query(
        'Comments',
        where: 'date = ?',
        whereArgs: [Comment.dateFormatter.format(date)]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Comment.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateComment(Comment comment) async {
    var client = await db;
    return client.update('Comments', comment.toMapForDb(),
        where: 'date = ?',
        whereArgs: [Comment.dateFormatter.format(comment.date)],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeComment(DateTime date) async {
    var client = await db;
    return client.delete('Comments',
        where: 'date = ?', whereArgs: [Comment.dateFormatter.format(date)]);
  }

  Future<List<Comment>> fetchAllComments() async {
    var client = await db;
    List<Map<String, dynamic>> maps = await client.query('Comments');
    return maps.map((i) => Comment.fromDb(i)).toList();
  }

  Future<int> saveOrUpdateComment(Comment comment) async {
    int updateResult = await updateComment(comment);
    return (updateResult > 0) ? updateResult : await addComment(comment);
  }
}
