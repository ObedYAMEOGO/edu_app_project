import 'package:edu_app_project/core/common/features/user/cubit/user_cubit.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatReplyTile extends StatefulWidget {
  const ChatReplyTile({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  State<ChatReplyTile> createState() => _ChatReplyTileState();
}

class _ChatReplyTileState extends State<ChatReplyTile> {
  LocalUser? replier;
  final auth = FirebaseAuth.instance;

  bool get isMyMessage => widget.message.senderId == auth.currentUser!.uid;

  bool get replyingToMe =>
      widget.message.messageBeingRepliedToSenderId == auth.currentUser!.uid;

  void getUser() {
    context
        .read<UserCubit>()
        .getUser(widget.message.messageBeingRepliedToSenderId!);
  }

  @override
  void initState() {
    super.initState();
    if (widget.message.messageBeingRepliedToSenderId != auth.currentUser!.uid) {
      getUser();
      replier = const LocalUserModel.empty().copyWith(
        fullName:
            widget.message.messageBeingRepliedToSenderName ?? 'Loading...',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFound) {
          setState(() {
            replier = state.user;
          });
        } else if (state is UserError) {
          setState(() {
            replier = const LocalUserModel.empty().copyWith(
              fullName: 'Supprimer cet Utilisateur',
            );
          });
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 40,
            minWidth: 100,
          ),
          decoration: BoxDecoration(
            color: isMyMessage ? Colours.primaryColour : Color(0xFFE4E6EA),
            border: Border(
              left: BorderSide(
                color:
                    isMyMessage ? Colours.successColor : Colours.favoriteYellow,
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                replyingToMe
                    ? 'Moi'
                    : replier?.fullName ?? 'En cours de chargement...',
                style: TextStyle(
                  fontSize: 12,
                  color: isMyMessage
                      ? Colours.successColor
                      : Colours.primaryColour,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.message.messageBeingRepliedToText!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      isMyMessage ? Color(0xFFE4E6EA) : Colours.primaryColour,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
