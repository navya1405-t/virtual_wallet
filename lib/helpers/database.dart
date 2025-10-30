import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    // For schema changes during development you may need to uninstall app or delete DB
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    // username is UNIQUE to avoid duplicates
    await db.execute(
      "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)",
    );
  }

  // Insert user — replace on conflict to avoid duplicate username rows
  Future<int> saveUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    user['username'] = (user['username'] as String).trim();
    // use replace so later saveUser updates existing user (during dev)
    int res = await dbClient.insert(
      "User",
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  // Get user for login (uses parameterized query)
  Future<Map<String, dynamic>?> getLogin(
    String username,
    String password,
  ) async {
    var dbClient = await db;
    username = username.trim();
    final res = await dbClient.query(
      'User',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // Get user by username (for debugging / verification)
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    var dbClient = await db;
    username = username.trim();
    final res = await dbClient.query(
      'User',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // Check if a user with this username exists
  Future<bool> userExists(String username) async {
    var dbClient = await db;
    username = username.trim();
    final res = await dbClient.query(
      'User',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  // Update password for a username
  Future<int> updatePassword(String username, String newPassword) async {
    var dbClient = await db;
    username = username.trim();
    return await dbClient.update(
      'User',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
