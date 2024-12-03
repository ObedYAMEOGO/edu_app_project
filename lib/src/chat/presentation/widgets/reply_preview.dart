import 'package:edu_app_project/core/common/app/providers/message_reply_notifier.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ReplyPreview extends StatelessWidget {
  const ReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageReplyNotifier>(
      builder: (_, notifier, __) {
        if (notifier.reply == null) {
          return const SizedBox();
        }
        final isMe =
            notifier.reply!.senderId == FirebaseAuth.instance.currentUser!.uid;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Color(0xFFE4E6EA),
              border: Border(
                left: BorderSide(
                  color: isMe ? Colours.successColor : Colours.favoriteYellow,
                  width: 5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isMe
                            ? 'Moi'
                            : notifier.reply!.messageBeingRepliedToSenderName ??
                                'Supprimer cet utilisateur',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Colours.successColor
                              : Colours.primaryColour,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: notifier.clearReply,
                      child: const Icon(IconlyBroken.close_square,
                          color: Colours.redColour, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notifier.reply!.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
