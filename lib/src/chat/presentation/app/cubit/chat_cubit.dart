import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_groups.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_messages.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_previous_messages.dart';
import 'package:edu_app_project/src/chat/domain/usecases/join_group.dart';
import 'package:edu_app_project/src/chat/domain/usecases/leave_group.dart';
import 'package:edu_app_project/src/chat/domain/usecases/send_message.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required SendMessage sendMessage,
    required GetMessages getMessages,
    required GetGroups getGroups,
    required JoinGroup joinGroup,
    required LeaveGroup leaveGroup,
    required GetPreviousMessages getPreviousMessages,
  })  : _sendMessage = sendMessage,
        _getMessages = getMessages,
        _getGroups = getGroups,
        _leaveGroup = leaveGroup,
        _getPreviousMessages = getPreviousMessages,
        _joinGroup = joinGroup,
        super(const ChatInitial());

  final SendMessage _sendMessage;
  final GetGroups _getGroups;
  final GetPreviousMessages _getPreviousMessages;
  final GetMessages _getMessages;
  final LeaveGroup _leaveGroup;
  final JoinGroup _joinGroup;

  Future<void> sendMessage(Message message) async {
    emit(const SendingMessage());
    final result = await _sendMessage(message);
    result.fold(
      (failure) => emit(ChatError('${failure.statusCode}: ${failure.message}')),
      (_) => emit(const MessageSent()),
    );
  }

  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    emit(const JoiningGroup());
    final result = await _joinGroup(
      JoinGroupParams(groupId: groupId, userId: userId),
    );
    result.fold(
      (failure) => emit(ChatError('${failure.statusCode}: ${failure.message}')),
      (_) => emit(const JoinedGroup()),
    );
  }

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    emit(const LeavingGroup());
    final result = await _leaveGroup(
      LeaveGroupParams(groupId: groupId, userId: userId),
    );
    result.fold(
      (failure) => emit(ChatError('${failure.statusCode}: ${failure.message}')),
      (_) => emit(const LeftGroup()),
    );
  }

  // Stream<Either<ChatError, List<Message>>> getMessages(String groupId) {
  //   return _getMessages(groupId).map((result) {
  //     return result.fold(
  //       (failure) =>
  //           Left(ChatError('${failure.statusCode}: ${failure.message}')),
  //       // same as (messages) => Right(messages)
  //       Right.new,
  //     );
  //   });
  // }

  void getMessages(String groupId) {
    emit(const LoadingMessages());

    StreamSubscription<Either<Failure, List<Message>>>? subscription;

    subscription = _getMessages(groupId).listen(
      (result) {
        result.fold(
          (failure) {
            emit(ChatError('${failure.statusCode}: ${failure.message}'));
            subscription?.cancel(); // Cancel the subscription on error
          },
          (messages) =>
              emit(MessagesLoaded(messages: messages, isPrevious: false)),
        );
      },
      onError: (error) {
        emit(const ChatError('An unexpected error occurred'));
        subscription?.cancel(); // Cancel the subscription on error
      },
      onDone: () {
        subscription?.cancel(); // Cancel the subscription when done
      },
    );
  }

  Future<void> getPreviousMessages({
    required String groupId,
    required String lastMessageId,
  }) async {
    emit(const LoadingMessages());
    final result = await _getPreviousMessages(
      GetPreviousMessagesParams(
        groupId: groupId,
        lastMessageId: lastMessageId,
      ),
    );
    result.fold(
      (failure) => emit(ChatError('${failure.statusCode}: ${failure.message}')),
      (messages) => emit(MessagesLoaded(messages: messages, isPrevious: true)),
    );
  }

  Stream<Either<ChatError, List<Group>>> getGroups() {
    return _getGroups().map((result) {
      return result.fold(
        (failure) =>
            Left(ChatError('${failure.statusCode}: ${failure.message}')),
        // same as (groups) => Right(groups)
        Right.new,
      );
    });
  }
}
