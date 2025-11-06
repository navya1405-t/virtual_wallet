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
    // bump version to 2 to create cards table; onUpgrade will run for existing DBs
    var ourDb = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return ourDb;
  }

  // create initial schema (both User and Card when creating fresh DB)
  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)",
    );

    await db.execute('''
      CREATE TABLE Card(
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        type TEXT,
        filename TEXT,
        front_path TEXT,
        back_path TEXT,
        uploaded_on TEXT,
        FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE
      )
    ''');
  }

  // upgrade path for existing DBs (v1 -> v2)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Card(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          type TEXT,
          filename TEXT,
          front_path TEXT,
          back_path TEXT,
          uploaded_on TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE
        )
      ''');
    }
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

  // Save a card map. If map contains 'user_id' it will be used,
  // otherwise use username to link card to a user via saveCardForUser.
  Future<int> saveCard(Map<String, dynamic> card) async {
    var dbClient = await db;

    // If caller provided user_id, insert directly
    if (card.containsKey('user_id') && card['user_id'] != null) {
      return await dbClient.insert('Card', card);
    }

    // If caller provided username, resolve to user_id and insert
    if (card.containsKey('username') && card['username'] != null) {
      final username = (card['username'] as String).trim();
      print(username);
      print("888888888888888888");
      final user = await getUserByUsername(username);
      if (user == null) {
        throw Exception('User "$username" not found');
      }
      final int userId = user['id'] as int;
      final Map<String, dynamic> toInsert = Map<String, dynamic>.from(card);
      toInsert.remove('username'); // don't store username in Card table
      toInsert['user_id'] = userId;
      return await dbClient.insert('Card', toInsert);
    }

    throw Exception(
      'saveCard requires user_id or username (use saveCardForUser or provide username in the map)',
    );
  }

  // Save card for a username (creates a card row linked to the user)
  Future<int> saveCardForUser(
    String username,
    Map<String, dynamic> card,
  ) async {
    var dbClient = await db;
    final user = await getUserByUsername(username);
    if (user == null) {
      throw Exception('User "$username" not found');
    }
    final int userId = user['id'] as int;
    final Map<String, dynamic> toInsert = Map<String, dynamic>.from(card);
    toInsert['user_id'] = userId;
    print(toInsert);
    print("******************************************");
    return await dbClient.insert('Card', toInsert);
  }

  // Retrieve all cards for a username
  Future<List<Map<String, dynamic>>> getCardsForUser(String username) async {
    var dbClient = await db;
    final user = await getUserByUsername(username);
    if (user == null) return <Map<String, dynamic>>[];
    final int userId = user['id'] as int;
    final res = await dbClient.query(
      'Card',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return res;
  }

  // Optional: get single card by id
  Future<Map<String, dynamic>?> getCardById(int id) async {
    var dbClient = await db;
    final res = await dbClient.query(
      'Card',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // Optional: delete a card
  Future<int> deleteCard(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Card', where: 'id = ?', whereArgs: [id]);
  }
}
