import 'package:equatable/equatable.dart';

class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
    required this.members,
    required this.courseId,
    this.lastMessage,
    this.lastMessageTimestamp,
    this.lastMessageSenderName,
    this.groupImageUrl = '',
  });

  Group.empty()
      : id = '',
        name = '',
        courseId = '',
        members = const [],
        lastMessage = '',
        groupImageUrl = '',
        lastMessageTimestamp = DateTime.now(),
        lastMessageSenderName = '';

  final String id;
  final String name;
  final String courseId;
  final List<String> members;
  final String? lastMessage;
  final String? groupImageUrl;
  final DateTime? lastMessageTimestamp;
  final String? lastMessageSenderName;

  @override
  List<Object?> get props => [id, name, courseId];
}

// To join a group, we add the user's id to the group's members list.
// next we add the group's id to the user's groups list.

// To leave a group, we remove the user's id from the group's members list.
// next we remove the group's id from the user's groups list.
