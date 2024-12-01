import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:flutter/foundation.dart';

class MessageReplyNotifier extends ChangeNotifier {
  factory MessageReplyNotifier() {
    return _instance;
  }

  MessageReplyNotifier._internal();

  static MessageReplyNotifier get instance => _instance;

  static final MessageReplyNotifier _instance =
      MessageReplyNotifier._internal();

  Message? _reply;

  Message? get reply => _reply;

  void setReply(Message message) {
    if (_reply != message) {
      _reply = message;
      notifyListeners();
    }
  }

  void clearReply() {
    _reply = null;
    notifyListeners();
  }
}
