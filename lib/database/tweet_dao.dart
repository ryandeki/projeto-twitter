import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:sqflite/sqflite.dart';

class TweetDao {
  TweetDao._();

  static final TweetDao instance = TweetDao._();

  Future<List<Tweet>> getFeedTweets() async {
    Database db = await DatabaseHelper.instance.database;
    var tweets = await db.query(
      'tweets',
      where: 'reply_to_tweet_id IS NULL',
      orderBy: 'id DESC',
    );
    return tweets.isNotEmpty
        ? tweets.map((item) => Tweet.fromMap(item)).toList()
        : [];
  }

  Future<List<Tweet>> getRepliesFromTweet(int tweetId) async {
    Database db = await DatabaseHelper.instance.database;
    var replies = await db.query(
      'tweets',
      where: 'reply_to_tweet_id = ?',
      whereArgs: [tweetId],
      orderBy: 'id DESC',
    );
    return replies.isNotEmpty
        ? replies.map((item) => Tweet.fromMap(item)).toList()
        : [];
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
      where: 'id = ?',
      whereArgs: [tweet.id],
    );
  }
}
