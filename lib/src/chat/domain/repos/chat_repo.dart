import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';

abstract class ChatRepo {
  const ChatRepo();

  ResultFuture<void> sendMessage(Message message);

  ResultStream<List<Group>> getGroups();

  ResultStream<List<Message>> getMessages(String groupId);

  ResultFuture<List<Message>> getPreviousMessages({
    required String groupId,
    required String lastMessageId,
  });

  ResultFuture<void> joinGroup({
    required String groupId,
    required String userId,
  });

  ResultFuture<void> leaveGroup({
    required String groupId,
    required String userId,
  });
}
