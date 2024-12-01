import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/repos/scholarship_repo.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/add_scholarship.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'scholarship_repo.mock.dart';

void main() {
  late ScholarshipRepo repo;
  late AddScholarship usecase;

  final tScholarship = Scholarship.empty();

  setUp(() {
    repo = MockScholarshipRepo();
    usecase = AddScholarship(repo);
    registerFallbackValue(tScholarship);
  });

  test(
    'should call [ScholarshipRepo.addScholarship]',
    () async {
      // arrange
      when(() => repo.addScholarship(any()))
          .thenAnswer((_) async => const Right(null));
      // act
      await usecase.call(tScholarship);
      // assert
      verify(() => repo.addScholarship(tScholarship)).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
