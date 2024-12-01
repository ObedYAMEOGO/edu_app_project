
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/add_scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/get_scholarships.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_cubit.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddScholarship extends Mock implements AddScholarship {}

class MockGetScholarships extends Mock implements GetScholarships {}

void main() {
  late AddScholarship addScholarship;
  late GetScholarships getScholarships;
  late ScholarshipCubit scholarshipCubit;

  final tScholarship = ScholarshipModel.empty();

  setUp(() {
    addScholarship = MockAddScholarship();
    getScholarships = MockGetScholarships();
    scholarshipCubit = ScholarshipCubit(
      addScholarship: addScholarship,
      getScholarships: getScholarships,
    );
    registerFallbackValue(tScholarship);
  });

  tearDown(() {
    scholarshipCubit.close();
  });

  test(
    'initial state should be [ScholarshipInitial]',
    () async {
      expect(scholarshipCubit.state, const ScholarshipInitial());
    },
  );

  group('addScholarship', () {
    blocTest<ScholarshipCubit, ScholarshipState>(
      'emits [AddingScholarship, ScholarshipAdded] when addScholarship is called',
      build: () {
        when(() => addScholarship(any()))
            .thenAnswer((_) async => const Right(null));
        return scholarshipCubit;
      },
      act: (cubit) => cubit.addScholarship(tScholarship),
      expect: () => const <ScholarshipState>[
        AddingScholarship(),
        ScholarshipAdded(),
      ],
      verify: (_) {
        verify(() => addScholarship(tScholarship)).called(1);
        verifyNoMoreInteractions(addScholarship);
      },
    );

    blocTest<ScholarshipCubit, ScholarshipState>(
      'emits [AddingScholarship, ScholarshipError] when addScholarship is called',
      build: () {
        when(() => addScholarship(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return scholarshipCubit;
      },
      act: (cubit) => cubit.addScholarship(tScholarship),
      expect: () => const <ScholarshipState>[
        AddingScholarship(),
        ScholarshipError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => addScholarship(tScholarship)).called(1);
        verifyNoMoreInteractions(addScholarship);
      },
    );
  });

  group('getScholarships', () {
    blocTest<ScholarshipCubit, ScholarshipState>(
      'emits [ScholarshipLoading, ScholarshipsLoaded] when getScholarships is called',
      build: () {
        when(() => getScholarships())
            .thenAnswer((_) async => Right([tScholarship]));
        return scholarshipCubit;
      },
      act: (cubit) => cubit.getScholarships(),
      expect: () => <ScholarshipState>[
        const LoadingScholarships(),
        ScholarshipsLoaded([tScholarship]),
      ],
      verify: (_) {
        verify(() => getScholarships()).called(1);
        verifyNoMoreInteractions(getScholarships);
      },
    );

    blocTest<ScholarshipCubit, ScholarshipState>(
      'emits [ScholarshipLoading,ScholarshipError] when getScholarships is called',
      build: () {
        when(() => getScholarships()).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return scholarshipCubit;
      },
      act: (cubit) => cubit.getScholarships(),
      expect: () => const <ScholarshipState>[
        LoadingScholarships(),
        ScholarshipError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getScholarships()).called(1);
        verifyNoMoreInteractions(getScholarships);
      },
    );
  });
}
