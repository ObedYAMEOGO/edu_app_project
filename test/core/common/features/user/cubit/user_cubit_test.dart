import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/user/cubit/user_cubit.dart';
import 'package:edu_app_project/core/common/features/user/domain/usecases/add_points.dart';
import 'package:edu_app_project/core/common/features/user/domain/usecases/get_user_by_id.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddPoints extends Mock implements AddPoints {}

class MockGetUserById extends Mock implements GetUserById {}

void main() {
  late AddPoints addPoints;
  late GetUserById getUserById;
  late UserCubit cubit;

  const tAddPointsParams = AddPointsParams.empty();
  final tUserId = tAddPointsParams.userId;
  const tUser = LocalUserModel.empty();
  const tFailure = ServerFailure(statusCode: 400, message: 'error');
  setUpAll(() => registerFallbackValue(tAddPointsParams));

  setUp(() {
    addPoints = MockAddPoints();
    getUserById = MockGetUserById();
    cubit = UserCubit(
      addPoints: addPoints,
      getUserById: getUserById,
    );
  });

  test('initial state is UserInitial', () async {
    expect(cubit.state, const UserInitial());
  });

  group('getUser', () {
    blocTest<UserCubit, UserState>(
      'emits [GettingUser, UserFound] when successful',
      build: () {
        when(() => getUserById(any())).thenAnswer(
          (_) async => const Right(tUser),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => const <UserState>[
        GettingUser(),
        UserFound(tUser),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [GettingUser, UserError] when unsuccessful',
      build: () {
        when(() => getUserById(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => [
        const GettingUser(),
        UserError('${tFailure.statusCode}: ${tFailure.message}'),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );
  });

  group('addPoints', () {
    blocTest<UserCubit, UserState>(
      'emits [AddingPoints, PointsAdded] when successful',
      build: () {
        when(() => addPoints(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.addPoints(userId: tUserId, points: 0),
      expect: () => const [
        AddingPoints(),
        PointsAdded(),
      ],
      verify: (_) {
        verify(() => addPoints(tAddPointsParams)).called(1);
        verifyNoMoreInteractions(addPoints);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [AddingPoints, UserError] when unsuccessful',
      build: () {
        when(() => addPoints(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.addPoints(
        userId: tUserId,
        points: 0,
      ),
      expect: () => [
        const AddingPoints(),
        UserError('${tFailure.statusCode}: ${tFailure.message}'),
      ],
      verify: (_) {
        verify(() => addPoints(tAddPointsParams)).called(1);
        verifyNoMoreInteractions(addPoints);
      },
    );
  });
}
