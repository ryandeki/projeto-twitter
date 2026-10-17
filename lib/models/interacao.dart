class Interacao {
  int? id;
  int userId;
  int tweetId;
  bool liked;
  bool reposted;

  Interacao({
    this.id,
    required this.userId,
    required this.tweetId,
    this.liked = false,
    this.reposted = false,
  });

  factory Interacao.fromMap(Map<String, dynamic> json) {
    return Interacao(
      id: json['id'],
      userId: json['user_id'],
      tweetId: json['tweet_id'],
      liked: json['liked'] == 1,
      reposted: json['reposted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'tweet_id': tweetId,
      'liked': liked ? 1 : 0,
      'reposted': reposted ? 1 : 0,
    };
  }
}
