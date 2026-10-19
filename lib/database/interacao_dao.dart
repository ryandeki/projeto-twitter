import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/database/tweet_dao.dart';
import 'package:projeto_twitter_ryan_mateo/database/user_dao.dart';
import 'package:projeto_twitter_ryan_mateo/models/interacao.dart';
import 'package:projeto_twitter_ryan_mateo/services/notification_service.dart';
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
    int result;

    if (interacaoExistente == null) {
      final novaInteracao = Interacao(
        userId: userId,
        tweetId: tweetId,
        liked: true,
      );
      result = await db.insert('interacoes', novaInteracao.toMap());
    } else {
      result = await db.update(
        'interacoes',
        {'liked': !currentLiked ? 1 : 0},
        where: 'user_id = ? AND tweet_id = ?',
        whereArgs: [userId, tweetId],
      );
    }

    if (!currentLiked) {
      _triggerNotification(
        actorUserId: userId,
        tweetId: tweetId,
        actionTitle: 'Nova curtida!',
        actionBody: 'curtiu a sua publicação.',
      );
    }

    return result;
  }

  Future<int> toggleRepost(
    int userId,
    int tweetId,
    bool currentReposted,
  ) async {
    Database db = await DatabaseHelper.instance.database;
    final interacaoExistente = await getInteracao(userId, tweetId);
    int result;

    if (interacaoExistente == null) {
      final novaInteracao = Interacao(
        userId: userId,
        tweetId: tweetId,
        reposted: true,
      );
      result = await db.insert('interacoes', novaInteracao.toMap());
    } else {
      result = await db.update(
        'interacoes',
        {'reposted': !currentReposted ? 1 : 0},
        where: 'user_id = ? AND tweet_id = ?',
        whereArgs: [userId, tweetId],
      );
    }

    if (!currentReposted) {
      _triggerNotification(
        actorUserId: userId,
        tweetId: tweetId,
        actionTitle: 'Novo repost!',
        actionBody: 'repostou a sua publicação.',
      );
    }

    return result;
  }

  Future<void> _triggerNotification({
    required int actorUserId,
    required int tweetId,
    required String actionTitle,
    required String actionBody,
  }) async {
    final tweet = await TweetDao.instance.getTweetById(tweetId);
    if (tweet == null) return;

    if (tweet.userId != actorUserId) {
      final actor = await UserDao.instance.getUserById(actorUserId);
      final actorName = actor?.username ?? 'Alguém';

      await NotificationService.instance.showNotification(
        id: tweetId,
        title: actionTitle,
        body: '@$actorName $actionBody',
      );
    }
  }
}
