import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:projeto_twitter_ryan_mateo/views/add_tweet.dart';

class TweetItem extends StatefulWidget {
  const TweetItem({super.key, required this.tweet, required this.deleteItem});
  final Tweet tweet;
  final Function() deleteItem;

  @override
  State<TweetItem> createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.0),
                    width: 4,
                  ),
                  color: Colors.grey.shade700.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Usuário',
                          style: TextStyle(
                            fontFamily: 'ClashGrotesk-Variable',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '@usuario - 1h',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'ClashGrotesk-Variable',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.tweet.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'ClashGrotesk-Variable',
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.tweet.photo != null) ...[
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade800,
                            width: 1,
                          ),
                          image: DecorationImage(
                            image: FileImage(widget.tweet.photo!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.tweet.like();
                              TweetDao.instance.update(widget.tweet);
                            });
                          },
                          icon: Icon(
                            widget.tweet.liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: widget.tweet.liked
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.tweet.repost();
                              TweetDao.instance.update(widget.tweet);
                            });
                          },
                          icon: Icon(
                            Icons.repeat_rounded,
                            size: 19,
                            color: widget.tweet.reposted
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddTweet(tweet: widget.tweet),
                              ),
                            );
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.mode_edit_outline_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            widget.deleteItem();
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 0.25, height: 20),
      ],
    );
  }
}
