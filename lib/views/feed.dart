import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:projeto_twitter_ryan_mateo/views/add_tweet.dart';
import 'package:projeto_twitter_ryan_mateo/views/tweet_item.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Center(
          child: Text(
            "TWITTER",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'ClashGrotesk-Variable',
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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

          FutureBuilder(
            future: TweetDao.instance.getTweets(),
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
                          Tweet currentTweet = snapShot.data![index];
                          return TweetItem(
                            tweet: currentTweet,
                            deleteItem: () => deleteTweet(currentTweet),
                          );
                        },
                      );
              } else if (snapShot.hasError) {
                return Center(child: Text(snapShot.error.toString()));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push<Tweet>(
            context,
            MaterialPageRoute(builder: (context) => const AddTweet()),
          );

          setState(() {});
        },
        backgroundColor: Colors.blue.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white),
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

  void deleteTweet(Tweet tweet) {
    setState(() {
      TweetDao.instance.remove(tweet);
    });
  }
}
