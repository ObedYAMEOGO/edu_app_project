import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Pigeon {
  const Pigeon({
    required this.messages,
    this.lastDocument,
    this.isFinalBatch = false,
  });

  const Pigeon.empty() : this(messages: const [], lastDocument: null);

  final List<Message> messages;
  final DocumentSnapshot? lastDocument;
  final bool isFinalBatch;
}
