import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef MessageStream = Stream<Either<ChatError, List<Message>>>;

class ChatController extends ChangeNotifier {
  ChatController({required FirebaseFirestore store}) : _store = store {
    positionListener.itemPositions.addListener(() {
      // when the user scrolls to the top of the list, fetch more messages
      if (positionListener.itemPositions.value.first.index == 0) {
        fetchMoreMessages();
      }
    });
  }

  final FirebaseFirestore _store;
  Group? _group;

  MessageStream? _messagesStream;

  late Query<Message> _messagesQuery;

  Query<Message> get messagesQuery => _messagesQuery;

  bool firstLoad = true;

  bool _shouldScrollToBottom = false;

  bool get shouldScrollToBottom => _shouldScrollToBottom;

  MessageStream? get messagesStream => _messagesStream;
  final _scrollController = ItemScrollController();
  final _positionListener = ItemPositionsListener.create();

  ItemScrollController get scrollController => _scrollController;

  ItemPositionsListener get positionListener => _positionListener;

  bool _isFetchingMore = false;

  String? _lastDocumentId;

  bool get isFetchingMore => _isFetchingMore;
  static const _documentLimit = 50;

  void init({required Group group, required MessageStream messagesStream}) {
    if (group != _group) {
      _group = group;
      _messagesQuery = _store
          .collection('groups')
          .doc(_group!.id)
          .collection('messages')
          .withConverter<Message>(
            fromFirestore: (snapshot, _) => MessageModel.fromMap(
              snapshot.data()!,
            ),
            toFirestore: (message, _) => (message as MessageModel).toMap(),
          );
    }
    if (messagesStream != _messagesStream) {
      _messagesStream = messagesStream;
    }
  }

  void changeLastDocumentId(String? lastDocumentId) {
    if (lastDocumentId != _lastDocumentId) {
      _lastDocumentId = lastDocumentId;
    }
  }

  void scrollToBottom() {
    if (firstLoad) {
      firstLoad = false;
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // scroll to the bottom
      final bottomIndex = await _messagesStream!.last
          .then((stream) => stream.getOrElse(() => []))
          .then((messages) => messages.length - 1);
      await _scrollController.scrollTo(
        index: bottomIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _shouldScrollToBottom = false;
    });
  }

  Future<void> fetchMoreMessages() async {
    _shouldScrollToBottom = true;
    try {
      if (!_isFetchingMore && _lastDocumentId != null) {
        _isFetchingMore = true;
        notifyListeners();
        final snapshot = await _store
            .collection('groups')
            .doc(_group!.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .startAfter([_lastDocumentId])
            .limit(_documentLimit)
            .get();
        _lastDocumentId =
            snapshot.docs.isNotEmpty ? snapshot.docs.last.id : null;
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList();
        _isFetchingMore = false;
        notifyListeners();
        if (messages.isNotEmpty) {
          // merge the new messages with the old ones in the stream, put them
          // before the old ones
          final oldStream = await _messagesStream!.last;
          final oldMessages = oldStream.getOrElse(() => []);
          final newMessages = [...oldMessages, ...messages];
          _messagesStream = Stream.value(Right(newMessages));
        }
      }
    } on FirebaseException catch (e) {
      _isFetchingMore = false;
      notifyListeners();
      _messagesStream = Stream.value(
        Left(ChatError('${e.code}: ${e.message ?? 'Unknown error'}')),
      );
    }
  }
}
