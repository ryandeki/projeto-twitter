import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/Comment.dart';
import 'package:sqflite/sqflite.dart';

class CommentDao {
  CommentDao._();

  static final CommentDao instance = CommentDao._();

  Future<List<Comment>> getTweetComments(int tweetId) async {
    Database db = await DatabaseHelper.instance.database;
    var comments = await db.query(
      'comments',
      where: 'tweet_id = ?',
      whereArgs: [tweetId],
      orderBy: 'id DESC',
    );
    List<Comment> commentList = comments.isNotEmpty
        ? comments.map((item) => Comment.fromMap(item)).toList()
        : [];

    return commentList;
  }

  Future<List<Comment>> getComments() async {
    Database db = await DatabaseHelper.instance.database;
    var comments = await db.query('comments', orderBy: 'id DESC');
    List<Comment> commentList = comments.isNotEmpty
        ? comments.map((item) => Comment.fromMap(item)).toList()
        : [];
    return commentList;
  }

  Future<int> add(Comment newComment) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('comments', newComment.toMap());
  }

  Future<int> remove(Comment comment) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }

  Future<int> update(Comment comment) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'comments',
      comment.toMap(),
      where: 'id  = ?',
      whereArgs: [comment.id],
    );
  }
}
