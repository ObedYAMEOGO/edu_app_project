import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final now = DateTime.now();
  final tMessage = MessageModel(
    id: '1',
    senderId: '1',
    message: 'Test message',
    groupId: '1',
    timestamp: now,
  );

  final tJson = fixture('message.json');
  final tMap = jsonDecode(tJson) as DataMap;
  tMap['timestamp'] = Timestamp.fromDate(now);

  test('should be a subclass of Message entity', () {
    expect(tMessage, isA<Message>());
  });

  group('fromMap', () {
    test(
      'should return a valid model when the map is valid',
      () async {
        final result = MessageModel.fromMap(tMap);

        expect(result, isA<MessageModel>());
        expect(result, tMessage);
      },
    );
  });

  group('toMap', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tMessage.toMap();
        expect(result, tMap);
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a copy of the model with the given fields',
      () async {
        final result = tMessage.copyWith(message: 'New message');
        expect(result, isA<MessageModel>());
        expect(result.message, 'New message');
      },
    );
  });
}
