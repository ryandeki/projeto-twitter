import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  static const int _version = 1;
  static const String _dbName = 'instagram_db.db';

  Future<Database> _initDatabase() async {
    Directory documentsDir = await getApplicationCacheDirectory();
    String path = join(documentsDir.path, _dbName);
    return openDatabase(path, onCreate: _createDb, version: _version);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tweets 
        (id INTEGER PRIMARY KEY AUTOINCREMENT, 
        text TEXT NOT NULL, 
        liked INTEGER NOT NULL, 
        photo BLOB, 
        reposted INTEGER NOT NULL)''');
  }
}

class TweetDao {
  TweetDao._();

  static final TweetDao instance = TweetDao._();

  Future<List<Tweet>> getTweets() async {
    Database db = await DatabaseHelper.instance.database;
    var tweets = await db.query('tweets', orderBy: 'id DESC');
    List<Tweet> tweetList = tweets.isNotEmpty
        ? tweets.map((item) => Tweet.fromMap(item)).toList()
        : [];
    return tweetList;
  }

  Future<int> add(Tweet newTweet) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('tweets', newTweet.toMap());
  }

  Future<int> remove(Tweet tweet) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('tweets', where: 'id = ?', whereArgs: [tweet.id]);
  }

  Future<int> update(Tweet tweet) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'tweets',
      tweet.toMap(),
      where: 'id  = ?',
      whereArgs: [tweet.id],
    );
  }
}
