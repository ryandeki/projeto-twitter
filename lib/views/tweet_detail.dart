import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/tweet_dao.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:projeto_twitter_ryan_mateo/models/user.dart';
import 'package:projeto_twitter_ryan_mateo/views/add_tweet.dart';
import 'package:projeto_twitter_ryan_mateo/views/tweet_item.dart';

class TweetDetail extends StatefulWidget {
  final Tweet tweet;
  final User currentUser;

  const TweetDetail({
    super.key,
    required this.tweet,
    required this.currentUser,
  });

  @override
  State<TweetDetail> createState() => _TweetDetailState();
}

class _TweetDetailState extends State<TweetDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do Post",
          style: TextStyle(
            fontFamily: 'ClashGrotesk-Variable',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView(
        children: [
          TweetItem(
            tweet: widget.tweet,
            currentUser: widget.currentUser,
            deleteItem: () async {
              await TweetDao.instance.remove(widget.tweet);
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
          FutureBuilder<List<Tweet>>(
            future: TweetDao.instance.getRepliesFromTweet(widget.tweet.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final comentarios = snapshot.data!;
                if (comentarios.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        "Nenhum comentário ainda. Seja o primeiro a responder!",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'ClashGrotesk-Variable',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final comentario = comentarios[index];
                    return TweetItem(
                      tweet: comentario,
                      currentUser: widget.currentUser,
                      deleteItem: () async {
                        await TweetDao.instance.remove(comentario);
                        setState(() {});
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTweet(
                currentUser: widget.currentUser,
                replyToTweetId: widget.tweet.id,
              ),
            ),
          );
          setState(() {});
        },
        backgroundColor: Colors.blue.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
}
