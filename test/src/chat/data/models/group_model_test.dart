import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/chat/data/models/group_model.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final now = DateTime.now();
  final tGroupModel = GroupModel(
    id: '1',
    courseId: '1',
    name: 'Test name',
    members: const [],
    lastMessage: 'Test last message',
    lastMessageTimestamp: now,
    lastMessageSenderName: 'Test sender name',
  );

  final tMap = jsonDecode(fixture('group.json')) as DataMap;
  tMap['lastMessageTimestamp'] = Timestamp.fromDate(now);

  test('should be a subclass of Group entity', () {
    expect(tGroupModel, isA<Group>());
  });

  group('fromMap', () {
    test(
      'should return a valid model when the map is valid',
      () async {
        final result = GroupModel.fromMap(tMap);

        expect(result, isA<GroupModel>());

        expect(result, tGroupModel);
      },
    );
  });

  group('toMap', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tGroupModel.toMap();
        expect(result, tMap);
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a copy of the model with the given fields',
      () async {
        final result = tGroupModel.copyWith(name: 'New name');
        expect(result, isA<GroupModel>());
        expect(result.name, 'New name');
      },
    );
  });
}
