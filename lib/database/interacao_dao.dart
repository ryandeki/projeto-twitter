import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/interacao.dart';
import 'package:sqflite/sqflite.dart';

class InteracaoDao {
  InteracaoDao._();

  static final InteracaoDao instance = InteracaoDao._();

  Future<int> saveOrUpdateInteracao(Interacao interacao) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(
      'interacoes',
      interacao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Interacao?> getInteracao(int userId, int tweetId) async {
    Database db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'interacoes',
      where: 'user_id = ? AND tweet_id = ?',
      whereArgs: [userId, tweetId],
    );

    if (maps.isNotEmpty) {
      return Interacao.fromMap(maps.first);
    }
    return null;
  }

  Future<int> toggleLike(int userId, int tweetId, bool currentLiked) async {
    Database db = await DatabaseHelper.instance.database;
    final interacaoExistente = await getInteracao(userId, tweetId);

    if (interacaoExistente == null) {
      final novaInteracao = Interacao(
        userId: userId,
        tweetId: tweetId,
        liked: true,
      );
      return await db.insert('interacoes', novaInteracao.toMap());
    } else {
      return await db.update(
        'interacoes',
        {'liked': !currentLiked ? 1 : 0},
        where: 'user_id = ? AND tweet_id = ?',
        whereArgs: [userId, tweetId],
      );
    }
  }

  Future<int> toggleRepost(
    int userId,
    int tweetId,
    bool currentReposted,
  ) async {
    Database db = await DatabaseHelper.instance.database;
    final interacaoExistente = await getInteracao(userId, tweetId);

    if (interacaoExistente == null) {
      final novaInteracao = Interacao(
        userId: userId,
        tweetId: tweetId,
        reposted: true,
      );
      return await db.insert('interacoes', novaInteracao.toMap());
    } else {
      return await db.update(
        'interacoes',
        {'reposted': !currentReposted ? 1 : 0},
        where: 'user_id = ? AND tweet_id = ?',
        whereArgs: [userId, tweetId],
      );
    }
  }
}
