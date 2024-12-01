import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:edu_app_project/src/leaderboard/domain/repos/leaderboard_repo.dart';
import 'package:edu_app_project/src/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLeaderboardRepo extends Mock implements LeaderboardRepo {}

void main() {
  late LeaderboardRepo repo;
  late GetLeaderboard usecase;

  setUp(() {
    repo = MockLeaderboardRepo();
    usecase = GetLeaderboard(repo);
  });

  test(
    'should emit [List<LeaderboardUser>] from the [LeaderboardRepo]',
    () async {
      const expectedUsers = [
        LeaderboardUser(
          userId: '1',
          name: 'John Doe',
          points: 100,
          image: 'https://example.com/image.png',
        ),
        LeaderboardUser(
          userId: '2',
          name: 'Jane Doe',
          points: 200,
          image: 'https://example.com/image.png',
        ),
      ];

      when(() => repo.getLeaderboard()).thenAnswer(
        (_) => Stream.value(const Right(expectedUsers)),
      );

      final stream = usecase();

      expect(
        stream,
        emitsInOrder(
          [const Right<dynamic, List<LeaderboardUser>>(expectedUsers)],
        ),
      );
      verify(() => repo.getLeaderboard()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
