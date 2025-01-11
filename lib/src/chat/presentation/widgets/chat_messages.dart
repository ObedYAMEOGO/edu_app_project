import 'package:edu_app_project/core/common/features/user/cubit/user_cubit.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/presentation/app/providers/chat_controller.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/message_bubble.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final errorListener = ValueNotifier<String?>(null);
  final newMessageListener = ValueNotifier<bool>(false);

  bool reversed = true;

  @override
  void initState() {
    super.initState();

    errorListener.addListener(() {
      if (errorListener.value != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          Utils.showSnackBar(context, errorListener.value!, ContentType.failure,
              title: 'Oups!');
          errorListener.value = null;
        });
      }
    });
    // because the messages get jumbled up when there's a new message, we
    // will listen to the newMessageListener and refresh the screen
    newMessageListener.addListener(() {
      if (newMessageListener.value) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          setState(() {});
          newMessageListener.value = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (_, controller, __) {
        return FirestoreQueryBuilder<Message>(
          query: controller.messagesQuery.orderBy(
            'timestamp',
            descending: true,
          ),
          pageSize: 20,
          builder: (_, snapshot, __) {
            if (snapshot.isFetching) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              errorListener.value = snapshot.error.toString();
            } else if (snapshot.hasData) {
              final messages = snapshot.docs.map((doc) => doc.data()).toList();
              newMessageListener.value = true;
              return ListView.builder(
                itemCount: messages.length,
                reverse: reversed,
                itemBuilder: (_, index) {
                  bool isEnd;
                  if (!reversed) {
                    isEnd = snapshot.hasMore &&
                        index + 1 == messages.length &&
                        !snapshot.isFetchingMore;
                  } else {
                    isEnd = snapshot.hasMore &&
                        index == 0 &&
                        !snapshot.isFetchingMore;
                  }
                  if (isEnd) {
                    snapshot.fetchMore();
                  }
                  final message = messages[index];
                  bool showSenderInfo;
                  if (!reversed) {
                    final previousMessage =
                        index > 0 ? messages[index - 1] : null;
                    showSenderInfo = previousMessage == null ||
                        previousMessage.senderId != message.senderId;
                  } else {
                    final nextMessage = index < messages.length - 1
                        ? messages[index + 1]
                        : null;
                    showSenderInfo = nextMessage == null ||
                        nextMessage.senderId != message.senderId;
                  }
                  /* we create a new bloc because we will have
                     multiple messages, and if they are all listening
                     to the same bloc, they will all be rebuilt
                     with the new values when one of them changes
                   */
                  return BlocProvider(
                    create: (context) => sl<UserCubit>(),
                    child: MessageBubble(
                      // TODO(DELETE): Remove this
                      isCurrentUser: false,
                      message: message,
                      showSenderInfo: showSenderInfo,
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CustomCircularProgressBarIndicator(),
            );
          },
        );
      },
    );
  }
}
