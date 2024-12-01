import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/user/domain/usecases/add_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'user_repo.mock.dart';

void main() {
  late MockUserRepo repo;
  late AddPoints usecase;

  setUp(() {
    repo = MockUserRepo();
    usecase = AddPoints(repo);
  });

  const tAddPointParams = AddPointsParams.empty();

  test(
    'should call [UserRepo.addPoints]',
    () async {
      when(
        () => repo.addPoints(
          userId: any(named: 'userId'),
          points: any(named: 'points'),
        ),
      ).thenAnswer((_) async => const Right(null));

      await usecase(tAddPointParams);

      verify(
        () => repo.addPoints(
          userId: tAddPointParams.userId,
          points: tAddPointParams.points,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
