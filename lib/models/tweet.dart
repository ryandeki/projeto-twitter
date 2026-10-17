import 'dart:io';
import 'dart:typed_data';

class Tweet {
  int? id;
  int userId;
  int? replyToTweetId;
  String text;
  bool liked;
  File? photo;
  bool reposted;

  Tweet({
    this.id,
    required this.userId,
    this.replyToTweetId,
    required this.text,
    this.liked = false,
    this.photo,
    this.reposted = false,
  });

  bool get isReply => replyToTweetId != null;

  void like() {
    liked = !liked;
  }

  void repost() {
    reposted = !reposted;
  }

  factory Tweet.fromMap(Map<String, dynamic> json, {Directory? tempDir}) {
    File? arquivoFoto;

    if (json['photo'] != null) {
      final Uint8List bytes = json['photo'] as Uint8List;

      final String tempPath = tempDir != null
          ? '${tempDir.path}/tweet_photo_${json['id'] ?? DateTime.now().millisecondsSinceEpoch}.jpg'
          : '${Directory.systemTemp.path}/tweet_photo_${json['id'] ?? DateTime.now().millisecondsSinceEpoch}.jpg';

      arquivoFoto = File(tempPath)..writeAsBytesSync(bytes);
    }

    return Tweet(
      id: json['id'],
      userId: json['user_id'],
      replyToTweetId: json['reply_to_tweet_id'],
      text: json['text'],
      liked: json['liked'] == 1,
      photo: arquivoFoto,
      reposted: json['reposted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'reply_to_tweet_id': replyToTweetId,
      'text': text,
      'liked': liked ? 1 : 0,
      'photo': photo?.readAsBytesSync(),
      'reposted': reposted ? 1 : 0,
    };
  }
}
