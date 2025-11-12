import '../helpers/database.dart';

/// Registers a user and returns the inserted row id.
/// Throws an [Exception] when validation fails or username already exists.
Future<int> registerUser({
  required String username,
  required String password,
}) async {
  final db = DatabaseHelper();
  final trimmed = username.trim();

  if (trimmed.length < 3) {
    throw Exception('Username must be at least 3 characters');
  }
  final exists = await db.userExists(trimmed);
  if (exists) {
    throw Exception('Username already exists');
  }

  final id = await db.saveUser({'username': trimmed, 'password': password});
  return id;
}
