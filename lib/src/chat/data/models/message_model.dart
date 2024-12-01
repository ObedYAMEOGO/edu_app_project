import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.message,
    required super.timestamp,
    required super.groupId,
    super.messageBeingRepliedToId,
    super.messageBeingRepliedToSenderId,
    super.messageBeingRepliedToText,
    super.messageBeingRepliedToSenderName,
  });

  MessageModel.empty()
      : this(
          id: '',
          senderId: '',
          message: '',
          groupId: '',
          timestamp: DateTime.now(),
        );

  MessageModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          senderId: map['senderId'] as String,
          message: map['message'] as String,
          groupId: map['groupId'] as String,
          timestamp:
              (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          messageBeingRepliedToId: map['messageBeingRepliedToId'] as String?,
          messageBeingRepliedToSenderId:
              map['messageBeingRepliedToSenderId'] as String?,
          messageBeingRepliedToText:
              map['messageBeingRepliedToText'] as String?,
          // I don't need the senderName at the point we are getting and
          // sending to the database, I would only need it locally,
          // when passing around the message reply
        );

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? message,
    String? groupId,
    DateTime? timestamp,
    String? messageBeingRepliedToId,
    String? messageBeingRepliedToSenderId,
    String? messageBeingRepliedToText,
    String? messageBeingRepliedToSenderName,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      groupId: groupId ?? this.groupId,
      timestamp: timestamp ?? this.timestamp,
      messageBeingRepliedToId:
          messageBeingRepliedToId ?? this.messageBeingRepliedToId,
      messageBeingRepliedToSenderId:
          messageBeingRepliedToSenderId ?? this.messageBeingRepliedToSenderId,
      messageBeingRepliedToText:
          messageBeingRepliedToText ?? this.messageBeingRepliedToText,
      messageBeingRepliedToSenderName: messageBeingRepliedToSenderName ??
          this.messageBeingRepliedToSenderName,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'message': message,
      'groupId': groupId,
      // ignore: unnecessary_null_comparison
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp)
          : FieldValue.serverTimestamp(),
      'messageBeingRepliedToId': messageBeingRepliedToId,
      'messageBeingRepliedToSenderId': messageBeingRepliedToSenderId,
      'messageBeingRepliedToText': messageBeingRepliedToText,
    };
  }
}
