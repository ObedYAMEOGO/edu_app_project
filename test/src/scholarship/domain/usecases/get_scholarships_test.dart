import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/repos/scholarship_repo.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/get_scholarships.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'scholarship_repo.mock.dart';

void main() {
  late ScholarshipRepo repo;
  late GetScholarships usecase;

  setUp(() {
    repo = MockScholarshipRepo();
    usecase = GetScholarships(repo);
  });

  test('should get scholarships from the repo', () async {
    // arrange
    when(() => repo.getScholarships()).thenAnswer((_) async => const Right([]));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right<dynamic, List<Scholarship>>([]));
    verify(() => repo.getScholarships()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
