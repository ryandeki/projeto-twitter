class Comment {
  int? id;
  String text;
  bool liked;
  int user_id;
  int tweet_id;

  Comment({
    this.id,
    required this.text,
    this.liked = false,
    required this.user_id,
    required this.tweet_id,
  });

  void like() {
    liked = !liked;
  }

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
    id: json['id'],
    text: json['text'],
    liked: json['id'] == 0 ? false : true,
    user_id: json['user_id'],
    tweet_id: json['tweet_id'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'liked': liked ? 1 : 0,
      'user_id': user_id,
      'tweet_id': tweet_id,
    };
  }
}
