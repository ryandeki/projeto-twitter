import 'dart:io';

import 'package:flutter/foundation.dart';

class Tweet {
  int? id;
  String text;
  bool liked;
  File? photo;
  bool reposted;

  Tweet({
    this.id,
    required this.text,
    this.liked = false,
    this.photo,
    this.reposted = false,
  });

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
      text: json['text'],
      liked: json['liked'] == 0 ? false : true,
      photo: arquivoFoto,
      reposted: json['reposted'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'liked': liked ? 1 : 0,
      'photo': photo != null ? photo!.readAsBytesSync() : null,
      'reposted': reposted ? 1 : 0,
    };
  }
}
