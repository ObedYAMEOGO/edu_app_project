import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/add_course.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/get_course.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/get_courses.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCourse extends Mock implements AddCourse {}

class MockGetCourses extends Mock implements GetCourses {}

class MockGetCourse extends Mock implements GetCourse {}

void main() {
  late AddCourse addCourse;
  late GetCourses getCourses;
  late GetCourse getCourse;
  late CourseCubit courseCubit;

  final tCourse = CourseModel.empty();

  setUp(() {
    addCourse = MockAddCourse();
    getCourses = MockGetCourses();
    getCourse = MockGetCourse();
    courseCubit = CourseCubit(
      addCourse: addCourse,
      getCourses: getCourses,
      getCourse: getCourse,
    );
    registerFallbackValue(tCourse);
  });

  tearDown(() {
    courseCubit.close();
  });

  test(
    'initial state should be [CourseInitial]',
    () async {
      expect(courseCubit.state, const CourseInitial());
    },
  );

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseAdded] when addCourse is called',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => const Right(null));
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseAdded(),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseError] when addCourse is called',
      build: () {
        when(() => addCourse(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });

  group('getCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CourseLoaded] when getCourse is called',
      build: () {
        when(() => getCourse(any())).thenAnswer((_) async => Right(tCourse));
        return courseCubit;
      },
      act: (cubit) => cubit.getCourse('1'),
      expect: () => <CourseState>[
        const LoadingCourses(),
        CourseLoaded(tCourse),
      ],
      verify: (_) {
        verify(() => getCourse('1')).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CourseError] when getCourse is called',
      build: () {
        when(() => getCourse(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return courseCubit;
      },
      act: (cubit) => cubit.getCourse('1'),
      expect: () => const <CourseState>[
        LoadingCourses(),
        CourseError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getCourse('1')).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });

  group('getCourses', () {
    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CoursesLoaded] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer((_) async => Right([tCourse]));
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => <CourseState>[
        const LoadingCourses(),
        CoursesLoaded([tCourse]),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CourseError] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => const <CourseState>[
        LoadingCourses(),
        CourseError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );
  });
}
