import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  UserDao._();

  static final UserDao instance = UserDao._();

  Future<int> insertUser(User user) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsernameAndPassword(
    String username,
    String password,
  ) async {
    try {
      Database db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await DatabaseHelper.instance.database;
    final map = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    final user = map.isNotEmpty ? User.fromMap(map.first) : null;
    return user;
  }

  Future<User?> getUserById(int id) async {
    Database db = await DatabaseHelper.instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> usernameExists(String username) async {
    Database db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isNotEmpty;
  }
}
