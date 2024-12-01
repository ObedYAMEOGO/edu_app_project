import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/app/providers/message_reply_notifier.dart';
import 'package:edu_app_project/core/common/app/providers/tab_navigator.dart';
import 'package:edu_app_project/core/common/features/user/cubit/user_cubit.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/chat_app_bar.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/chat_input_field.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/message_bubble.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/reply_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class GroupChatView extends StatefulWidget {
  const GroupChatView({required this.group, super.key});

  final Group group;

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final messageScrollController = ScrollController();

  final errorListener = ValueNotifier<String?>(null);

  bool loading = false;

  List<Message> messages = [];

  void getMessages() {
    context.read<ChatCubit>().getMessages(widget.group.id);
  }

  void getPreviousMessages() {
    final lastMessageId = messages.last.id;
    context.read<ChatCubit>().getPreviousMessages(
          groupId: widget.group.id,
          lastMessageId: lastMessageId,
        );
  }

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // scroll to the bottom
      await messageScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      await SchedulerBinding.instance.endOfFrame;
    });
  }

  @override
  void initState() {
    getMessages();
    super.initState();
    messageScrollController.addListener(() {
      if (messageScrollController.position.pixels ==
          messageScrollController.position.maxScrollExtent) {
        getPreviousMessages();
      }
    });
    errorListener.addListener(() {
      if (errorListener.value != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          Utils.showSnackBar(context, errorListener.value!, ContentType.failure,
              title: 'Oups!');
          errorListener.value = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          Utils.showSnackBar(
              context,
              'Une erreur s\'est produite. Verifier votre connexion internet puis réessayer!',
              ContentType.failure,
              title: 'Oups!');
        } else if (state is LeavingGroup) {
          Utils.showLoadingDialog(context);
          loading = true;
        } else if (state is LeftGroup) {
          if (loading) {
            Navigator.pop(context);
            loading = false;
          }
          context.read<TabNavigator>().pop();
        } else if (state is MessagesLoaded) {
          if (state.isPrevious) {
            messages.addAll(state.messages);
          } else {
            messages = state.messages;
            scrollToBottom();
          }
          setState(() {});
        }
      },
      builder: (_, state) => Consumer<MessageReplyNotifier>(
        builder: (_, notifier, __) {
          return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: ChatAppBar(group: widget.group,),
            body: GradientBackground(
              image: Res.chatScreenBackgroundImage,
              child: Column(
                children: [
                  if (state is LoadingMessages) ...[
                    const LinearProgressIndicator(
                      minHeight: 1,
                      valueColor:
                          AlwaysStoppedAnimation(Colours.lightGoldenColor),
                    ),
                  ],
                  Expanded(
                    child: ListView.builder(
                      controller: messageScrollController,
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (_, index) {
                        final messages = this.messages
                          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                        final message = messages[index];
                        // final previousMessage =
                        //     index > 0 ? messages[index - 1] : null;
                        // final showSenderInfo = previousMessage == null ||
                        //     previousMessage.senderId != message.senderId;
                        final previousMessage = index < messages.length - 1
                            ? messages[index + 1]
                            : null;
                        final showSenderInfo = previousMessage == null ||
                            previousMessage.senderId != message.senderId;
                        /* we create a new bloc because we will have
                              multiple messages, and if they are all listening
                              to the same bloc, they will all be rebuilt with the
                              new values when one of them changes
                               */
                        return BlocProvider(
                          create: (context) => sl<UserCubit>(),
                          child: MessageBubble(
                            message: message,
                            showSenderInfo: showSenderInfo,
                            isCurrentUser:
                                message.senderId == context.currentUser?.uid,
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (notifier.reply != null) ...[
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: ReplyPreview(),
                        ),
                      ],
                      BlocProvider(
                        create: (context) => sl<ChatCubit>(),
                        child: ChatInputField(groupId: widget.group.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
