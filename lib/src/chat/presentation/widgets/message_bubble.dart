import 'package:edu_app_project/core/common/app/providers/message_reply_notifier.dart';
import 'package:edu_app_project/core/common/features/user/cubit/user_cubit.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/chat_reply_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.message,
    required this.showSenderInfo,
    required this.isCurrentUser,
    super.key,
  });

  final Message message;
  final bool showSenderInfo;
  final bool isCurrentUser;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  LocalUser? user;

  void getUser() {
    context.read<UserCubit>().getUser(widget.message.senderId);
  }

  final auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    if (widget.isCurrentUser) {
      user = context.currentUser;
    } else {
      getUser();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (widget.isCurrentUser) {
      user = context.currentUser;
    } else {
      getUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFound) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: SwipeTo(
        onRightSwipe: (swipe) {
          context.read<MessageReplyNotifier>().setReply(
                (widget.message as MessageModel).copyWith(
                  messageBeingRepliedToSenderName: user?.fullName,
                ),
              );
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 40,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: widget.isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!widget.isCurrentUser &&
                  widget.showSenderInfo &&
                  user != null)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: user?.profilePic == null
                          ? null
                          : NetworkImage(user!.profilePic!),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user!.fullName,
                      style: TextStyle(
                        fontFamily:
                            Fonts.inter, // Texte légèrement plus clair
                      ),
                    ),
                  ],
                ),
              Container(
                // 40 because if avatar radius is 16, then the actual width and
                // height is 32, whereas the space between the avatar and the
                // message bubble is 8, so 32 + 8 = 40
                margin: EdgeInsets.only(
                  top: 4,
                  left: widget.isCurrentUser ? 0 : 20,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: widget.message.isReply ? 8 : 16,
                ),
                decoration: BoxDecoration(
                  color: widget.isCurrentUser
                      ? Colours.primaryColour
                      : Color(0xFFE4E6EA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.message.isReply) ...[
                      BlocProvider(
                        create: (context) => sl<UserCubit>(),
                        child: ChatReplyTile(message: widget.message),
                      ),
                      const SizedBox(height: 5),
                    ],
                    Text(
                      widget.message.message,
                      style: TextStyle(
                        fontFamily:
                            Fonts.inter, // Texte légèrement plus clair

                        color: widget.isCurrentUser
                            ? Colors.white
                            : Colours.primaryColour,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
