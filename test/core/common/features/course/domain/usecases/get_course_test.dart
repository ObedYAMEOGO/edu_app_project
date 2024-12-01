import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/domain/repos/course_repo.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/get_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late GetCourse usecase;

  setUp(() {
    repo = MockCourseRepo();
    usecase = GetCourse(repo);
  });

  final tCourse = Course.empty();

  test('should get course from the repo', () async {
    // arrange
    when(() => repo.getCourse(any())).thenAnswer((_) async => Right(tCourse));
    // act
    final result = await usecase('1');
    // assert
    expect(result, equals(Right<dynamic, Course>(tCourse)));
    verify(() => repo.getCourse('1')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
