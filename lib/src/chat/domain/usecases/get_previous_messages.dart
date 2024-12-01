import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/domain/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';

class GetPreviousMessages
    extends FutureUsecaseWithParams<List<Message>, GetPreviousMessagesParams> {
  const GetPreviousMessages(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<List<Message>> call(GetPreviousMessagesParams params) =>
      _repo.getPreviousMessages(
        groupId: params.groupId,
        lastMessageId: params.lastMessageId,
      );
}

class GetPreviousMessagesParams extends Equatable {
  const GetPreviousMessagesParams({
    required this.groupId,
    required this.lastMessageId,
  });

  const GetPreviousMessagesParams.empty()
      : groupId = '',
        lastMessageId = '';

  final String groupId;
  final String lastMessageId;

  @override
  List<Object?> get props => [groupId, lastMessageId];
}
