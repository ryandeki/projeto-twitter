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
  static const String _dbName = 'twitter_v1.db';

  Future<Database> _initDatabase() async {
    Directory documentsDir = await getApplicationCacheDirectory();
    String path = join(documentsDir.path, _dbName);
    return openDatabase(path, onCreate: _createDb, version: _version);
  }

  Future<void> _createDb(Database db, int version) async {
    // 1. Tabela de Usuários
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
  ''');

    // 2. Tabela de Tweets
    await db.execute('''
    CREATE TABLE tweets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      reply_to_tweet_id INTEGER,
      text TEXT NOT NULL,
      liked INTEGER DEFAULT 0,
      photo BLOB,
      reposted INTEGER DEFAULT 0,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
      FOREIGN KEY (reply_to_tweet_id) REFERENCES tweets (id) ON DELETE CASCADE
    )
  ''');

    // 3. Tabela de Interações
    await db.execute('''
    CREATE TABLE interacoes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      tweet_id INTEGER NOT NULL,
      liked INTEGER DEFAULT 0,
      reposted INTEGER DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
      FOREIGN KEY (tweet_id) REFERENCES tweets (id) ON DELETE CASCADE,
      UNIQUE(user_id, tweet_id)
    )
  ''');
  }
}
