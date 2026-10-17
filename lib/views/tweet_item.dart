import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/interacao_dao.dart';
import 'package:projeto_twitter_ryan_mateo/database/user_dao.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';
import 'package:projeto_twitter_ryan_mateo/models/user.dart';
import 'package:projeto_twitter_ryan_mateo/views/add_tweet.dart';
import 'package:projeto_twitter_ryan_mateo/views/profile.dart';
import 'package:projeto_twitter_ryan_mateo/views/tweet_detail.dart';

class TweetItem extends StatefulWidget {
  const TweetItem({
    super.key,
    required this.tweet,
    required this.currentUser,
    required this.deleteItem,
  });

  final Tweet tweet;
  final User currentUser;
  final Function() deleteItem;

  @override
  State<TweetItem> createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  void _confirmDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Deseja excluir esse tweet?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ClashGrotesk-Variable',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700.withValues(
                        alpha: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      "Não",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ClashGrotesk-Variable',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      widget.deleteItem();
                    },
                    child: const Text(
                      "Sim",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ClashGrotesk-Variable',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTweetsOwner = widget.currentUser.id == widget.tweet.userId;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TweetDetail(
                  tweet: widget.tweet,
                  currentUser: widget.currentUser,
                ),
              ),
            );
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (widget.tweet.userId == widget.currentUser.id) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(user: widget.currentUser),
                        ),
                      );
                    }
                  },
                  child: Container(
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
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<User?>(
                        future: UserDao.instance.getUserById(
                          widget.tweet.userId,
                        ),
                        builder: (context, snapshot) {
                          final autor = snapshot.data;
                          final username = autor?.username ?? 'usuario';

                          return Row(
                            children: [
                              Text(
                                '@$username',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'ClashGrotesk-Variable',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tweet.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'ClashGrotesk-Variable',
                        ),
                      ),
                      if (widget.tweet.photo != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
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
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (widget.currentUser.id != null &&
                                  widget.tweet.id != null) {
                                await InteracaoDao.instance.toggleLike(
                                  widget.currentUser.id!,
                                  widget.tweet.id!,
                                  widget.tweet.liked,
                                );
                                setState(() {
                                  widget.tweet.like();
                                });
                              }
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
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              if (widget.currentUser.id != null &&
                                  widget.tweet.id != null) {
                                await InteracaoDao.instance.toggleRepost(
                                  widget.currentUser.id!,
                                  widget.tweet.id!,
                                  widget.tweet.reposted,
                                );
                                setState(() {
                                  widget.tweet.repost();
                                });
                              }
                            },
                            icon: Icon(
                              Icons.repeat_rounded,
                              size: 19,
                              color: widget.tweet.reposted
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
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
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                          if (isTweetsOwner) ...[
                            const SizedBox(width: 10),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                size: 18,
                                color: Colors.grey,
                              ),
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.4,
                                ),
                              ),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTweet(
                                        currentUser: widget.currentUser,
                                        tweet: widget.tweet,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                } else if (value == 'delete') {
                                  _confirmDeleteDialog(context);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Editar',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'ClashGrotesk-Variable',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Excluir',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontFamily: 'ClashGrotesk-Variable',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 0.25, height: 20),
      ],
    );
  }
}
