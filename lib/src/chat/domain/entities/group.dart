import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

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

  String get formattedLastMessageTimestamp {
    if (lastMessageTimestamp == null) return "Aucun message";

    final now = DateTime.now();
    final difference = now.difference(lastMessageTimestamp!);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return "Hier";
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'fr_FR')
          .format(lastMessageTimestamp!); // Day name in French
    } else {
      return DateFormat('dd MMM yyyy', 'fr_FR').format(lastMessageTimestamp!);
    }
  }

  Group.empty()
      : id = '',
        name = '',
        courseId = '',
        members = const [],
        lastMessage = '',
        groupImageUrl = '',
        lastMessageTimestamp = null, // Set to null instead of DateTime.now()
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
