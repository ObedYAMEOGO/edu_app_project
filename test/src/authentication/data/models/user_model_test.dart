import 'dart:convert';

import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel(
    uid: '1',
    email: 'Test email',
    points: 0,
    fullName: 'Test name',
    profilePic: 'Test profile pic',
    bio: 'Test bio',
    groupIds: ['1', '2'],
    enrolledCourseIds: ['1', '2'],
    following: ['1', '2'],
    followers: ['1', '2'],
  );

  group('LocalUserModel', () {
    test('should be a subclass of LocalUser entity', () {
      expect(tLocalUserModel, isA<LocalUser>());
    });
  });
  group('fromMap', () {
    test(
      'should return a valid [LocalUserModel] from a valid map',
      () async {
        final map = jsonDecode(fixture('user.json')) as DataMap;

        final result = LocalUserModel.fromMap(map);

        expect(result, isA<LocalUserModel>());
        expect(result, equals(tLocalUserModel));
      },
    );
    test(
      'should throw a [Error] when the map is invalid',
      () async {
        final map = jsonDecode(fixture('user.json')) as DataMap..remove('uid');

        final secondMap = jsonDecode(fixture('user.json')) as DataMap
          ..update('uid', (value) => 1);

        const call = LocalUserModel.fromMap;

        expect(() => call(map), throwsA(isA<Error>()));

        expect(() => call(secondMap), throwsA(isA<Error>()));
      },
    );
  });
  group('toMap', () {
    test(
      'should return a valid [DataMap] from a valid [LocalUserModel]',
      () async {
        final result = tLocalUserModel.toMap();

        expect(result, equals(jsonDecode(fixture('user.json'))));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a valid [LocalUserModel] with updated values',
      () async {
        final result = tLocalUserModel.copyWith(uid: '2');

        expect(result, isA<LocalUserModel>());
        expect(result.uid, '2');
      },
    );
  });
}
