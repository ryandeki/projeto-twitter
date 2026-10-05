import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  static const int _version = 1;
  static const String _dbName = 'twitter_db.db';

  Future<Database> _initDatabase() async {
    Directory documentsDir = await getApplicationCacheDirectory();
    String path = join(documentsDir.path, _dbName);
    return openDatabase(path, onCreate: _createDb, version: _version);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      );
    ''');

    await db.execute('''
      CREATE TABLE tweets 
        (id INTEGER PRIMARY KEY AUTOINCREMENT, 
        text TEXT NOT NULL, 
        liked INTEGER NOT NULL, 
        photo BLOB, 
        reposted INTEGER NOT NULL,
        user_id INTEGER,
        created_at TIMESTAMP DEFAULT NOW(),
        FOREIGN KEY user_id REFERENCES users(id) ON DELETE CASCADE
        );
    ''');

    await db.execute('''
      CREATE TABLE comments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      liked INTEGER NOT NULL,
      user_id INTEGER,
      tweet_id INTEGER,
      FOREIGN KEY user_id REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY tweet_id REFERENCES tweets(id) ON DELETE CASCADE,
      );
    ''');
  }
}
