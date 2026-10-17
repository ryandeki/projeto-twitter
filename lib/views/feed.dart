import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/tweet_dao.dart';
import 'package:projeto_twitter_ryan_mateo/models/user.dart';

import '../models/tweet.dart';
import 'add_tweet.dart';
import 'profile.dart';
import 'tweet_item.dart';

class Feed extends StatefulWidget {
  final User user;

  const Feed({super.key, required this.user});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TWITTER")),
      body: ListView(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Para Você",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontFamily: 'ClashGrotesk-Variable',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, thickness: 0.25, height: 20),

          FutureBuilder<List<Tweet>>(
            future: TweetDao.instance.getFeedTweets(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return snapShot.data!.isEmpty
                    ? Center(
                        child: Text(
                          "Nenhum tweet",
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontFamily: 'ClashGrotesk-Variable',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapShot.data!.length,
                        itemBuilder: (context, index) {
                          final currentTweet = snapShot.data![index];
                          return TweetItem(
                            tweet: currentTweet,
                            currentUser: widget.user,
                            deleteItem: () => deleteTweet(currentTweet),
                          );
                        },
                      );
              } else if (snapShot.hasError) {
                return Center(child: Text(snapShot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptionsSheet(context);
        },
        backgroundColor: Colors.blue.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.more_vert, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        color: Colors.black,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.0),
                width: 3,
              ),
              color: Colors.grey.shade700.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              iconSize: 25,
              icon: Icon(Icons.home_filled, color: Colors.blue.shade600),
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "add_tweet_btn",
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push<Tweet>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTweet(currentUser: widget.user),
                    ),
                  );
                  setState(() {});
                },
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "profile_btn",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(user: widget.user),
                    ),
                  );
                },
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteTweet(Tweet tweet) async {
    await TweetDao.instance.remove(tweet);
    setState(() {});
  }
}
