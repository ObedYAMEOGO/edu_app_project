import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/leaderboard/data/datasources/leaderboard_remote_data_src.dart';
import 'package:edu_app_project/src/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:edu_app_project/src/leaderboard/data/repos/leaderboard_repo_impl.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSrc extends Mock implements LeaderboardRemoteDataSrc {}

void main() {
  late LeaderboardRemoteDataSrc remoteDataSrc;
  late LeaderboardRepoImpl repoImpl;

  setUp(() {
    remoteDataSrc = MockRemoteDataSrc();
    repoImpl = LeaderboardRepoImpl(remoteDataSrc);
  });

  group('getLeaderboard', () {
    // always extract this here or else it'll give error
    // Expected: should emit an event that Right<Failure,
    // List<LeaderboardUser>>:<Right([LeaderboardUserModel(_empty.userId,
    // _empty.name, 0)])> Actual: <Instance of '_BoundSinkStream<List<Leaderb
    // oardUserModel>, Either<Failure, List<LeaderboardUser>>>'> Which:
    // emitted • Right([LeaderboardUserModel(_empty.userId, _empty.name, 0)])
    // x Stream closed.
    const expectedUsers = [
      LeaderboardUserModel.empty(),
      LeaderboardUserModel(
        name: 'name',
        userId: 'userId',
        points: 10,
        image: 'image',
      ),
    ];
    test(
      'should emit [List<LeaderboardUser>] when call to remote source is '
      'successful',
      () {
        when(() => remoteDataSrc.getLeaderboard()).thenAnswer(
          (_) => Stream.value(expectedUsers),
        );

        final stream = repoImpl.getLeaderboard();

        expect(
          stream,
          emits(const Right<Failure, List<LeaderboardUser>>(expectedUsers)),
        );

        verify(() => remoteDataSrc.getLeaderboard()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should emit ServerFailure when call to remote source is '
      'unsuccessful',
      () {
        const exception = ServerException(
          message: 'message',
          statusCode: '404',
        );
        when(() => remoteDataSrc.getLeaderboard())
            .thenAnswer((_) => Stream.error(exception));

        final stream = repoImpl.getLeaderboard();

        expect(
          stream,
          emits(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(exception),
            ),
          ),
        );

        verify(() => remoteDataSrc.getLeaderboard()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
