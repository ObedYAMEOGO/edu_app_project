part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class LoadingGroups extends ChatState {
  const LoadingGroups();
}

class LoadingMessages extends ChatState {
  const LoadingMessages();
}

class SendingMessage extends ChatState {
  const SendingMessage();
}

class JoiningGroup extends ChatState {
  const JoiningGroup();
}

class LeavingGroup extends ChatState {
  const LeavingGroup();
}

class MessageSent extends ChatState {
  const MessageSent();
}

class GroupsLoaded extends ChatState {
  const GroupsLoaded(this.groups);

  final List<Group> groups;

  @override
  List<Object> get props => [groups];
}

class MessagesLoaded extends ChatState {
  /// A ChatState for when the [messages] have been fetched from the server.
  ///
  /// [isPrevious] will be true when the messages are from pagination fetch
  /// and not the latest messages
  const MessagesLoaded({
    required this.messages,
    required this.isPrevious,
  });

  final List<Message> messages;
  final bool isPrevious;

  @override
  List<Object> get props => [messages, isPrevious];
}

class LeftGroup extends ChatState {
  const LeftGroup();
}

class JoinedGroup extends ChatState {
  const JoinedGroup();
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
