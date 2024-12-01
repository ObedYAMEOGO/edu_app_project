import 'dart:convert';

import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLeaderboardUser = LeaderboardUserModel.empty();

  test(
    'should be a subclass of the [LeaderboardUser]',
    () {
      expect(tLeaderboardUser, isA<LeaderboardUser>());
    },
  );

  final map = jsonDecode(fixture('leaderboard_user.json')) as DataMap;

  group('fromMap', () {
    test(
      'should return a [LeaderboardUserModel] from the map',
      () {
        final result = LeaderboardUserModel.fromMap(map);

        expect(result, isA<LeaderboardUserModel>());
        expect(result, equals(tLeaderboardUser));
      },
    );

    test(
      'should throw an [Error] when there is a dart error]',
      () {
        final errorMap = DataMap.from(map)..remove('fullName');

        const call = LeaderboardUserModel.fromMap;

        expect(() => call(errorMap), throwsA(isA<Error>()));
      },
    );
  });

  group('toMap', () {
    test(
      'should should return a proper map',
      () {
        final result = tLeaderboardUser.toMap();

        expect(result, equals(map));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a [LeaderboardUserModel] with the new data',
      () async {
        final result = tLeaderboardUser.copyWith(name: 'New User');

        expect(result, isA<LeaderboardUserModel>());
        expect(result.name, 'New User');
      },
    );
  });
}
