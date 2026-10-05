import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:sqflite/sqflite.dart';

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
