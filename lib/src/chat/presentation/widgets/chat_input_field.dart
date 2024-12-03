import 'package:edu_app_project/core/common/app/providers/message_reply_notifier.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({required this.groupId, super.key});

  final String groupId;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final controller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<MessageReplyNotifier>().addListener(() {
      if (!mounted) return;
      if (context.read<MessageReplyNotifier>().reply != null) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        // text-field should expand and collapse based on the content
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Message',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Color(0xFFE4E6EA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Transform.scale(
            scale: .75,
            child: IconButton.filled(
              padding: EdgeInsets.zero,
              icon: const Icon(IconlyLight.send, color: Colors.white),
              onPressed: () async {
                final message = controller.text.trim();
                if (message.isEmpty) return;
                final replyNotifier = context.read<MessageReplyNotifier>();
                final reply = replyNotifier.reply;
                replyNotifier.clearReply();
                controller.clear();
                await context.read<ChatCubit>().sendMessage(
                      MessageModel.empty().copyWith(
                        message: message,
                        senderId: auth.currentUser!.uid,
                        groupId: widget.groupId,
                        timestamp: DateTime.now(),
                        messageBeingRepliedToId: reply?.id,
                        messageBeingRepliedToSenderId: reply?.senderId,
                        messageBeingRepliedToText: reply?.message,
                      ),
                    );
              },
              style: IconButton.styleFrom(
                backgroundColor:
                    Colours.successColor, // Set the background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(50), // Optional: make it circular
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
