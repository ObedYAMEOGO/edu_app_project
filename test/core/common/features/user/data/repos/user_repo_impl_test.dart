import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/user/data/datasources/user_remote_data_source.dart';
import 'package:edu_app_project/core/common/features/user/data/repos/user_repo_impl.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRemoteDataSource remoteDataSource;
  late UserRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockUserRemoteDataSource();
    repoImpl = UserRepoImpl(remoteDataSource);
  });

  const tUserId = 'ds9d0f29f0s9df02';
  const tPoints = 0;

  const tLocalUser = LocalUserModel.empty();

  group('addPoints', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(
          () => remoteDataSource.addPoints(
            userId: any(named: 'userId'),
            points: any(named: 'points'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.addPoints(
          userId: tUserId,
          points: tPoints,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => remoteDataSource.addPoints(
            userId: tUserId,
            points: tPoints,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.addPoints(
            userId: any(named: 'userId'),
            points: any(named: 'points'),
          ),
        ).thenThrow(
          const ServerException(message: 'message', statusCode: 'statusCode'),
        );

        final result = await repoImpl.addPoints(
          userId: tUserId,
          points: tPoints,
        );

        expect(
          result,
          equals(
            const Left<dynamic, void>(
              ServerFailure(message: 'message', statusCode: 'statusCode'),
            ),
          ),
        );

        verify(
          () => remoteDataSource.addPoints(
            userId: tUserId,
            points: tPoints,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUserById', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(
          () => remoteDataSource.getUserById(
            any(),
          ),
        ).thenAnswer((_) async => tLocalUser);

        final result = await repoImpl.getUserById(tUserId);

        expect(result, equals(const Right<dynamic, LocalUser>(tLocalUser)));

        verify(() => remoteDataSource.getUserById(tUserId)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.getUserById(
            any(),
          ),
        ).thenThrow(
          const ServerException(message: 'message', statusCode: 'statusCode'),
        );

        final result = await repoImpl.getUserById(tUserId);

        expect(
          result,
          equals(
            const Left<dynamic, LocalUser>(
              ServerFailure(message: 'message', statusCode: 'statusCode'),
            ),
          ),
        );

        verify(() => remoteDataSource.getUserById(tUserId)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
