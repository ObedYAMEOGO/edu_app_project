

import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/scholarship/data/datasources/scholarship_remote_data_source.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:edu_app_project/src/scholarship/data/repos/scholarship_repo_impl.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScholarshipRemoteDataSrc extends Mock
    implements ScholarshipRemoteDataSrcImpl {}

void main() {
  late ScholarshipRemoteDataSrcImpl remoteDataSrc;
  late ScholarshipRepoImpl repoImpl;

  final tScholarship = ScholarshipModel.empty();

  setUp(() {
    remoteDataSrc = MockScholarshipRemoteDataSrc();
    repoImpl = ScholarshipRepoImpl(remoteDataSrc);
    registerFallbackValue(tScholarship);
  });

  const tException = ServerException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addScholarship', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.addScholarship(any())).thenAnswer(
          (_) async => Future.value(),
        );
        final result = await repoImpl.addScholarship(tScholarship);
        expect(result, const Right<dynamic, void>(null));
        verify(() => remoteDataSrc.addScholarship(tScholarship)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.addScholarship(any())).thenThrow(tException);

        final result = await repoImpl.addScholarship(tScholarship);
        expect(
          result,
          Left<Failure, void>(ServerFailure.fromException(tException)),
        );

        verify(() => remoteDataSrc.addScholarship(tScholarship)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getScholarships', () {
    test(
      'should return [List<Scholarship>] when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.getScholarships()).thenAnswer(
          (_) async => [tScholarship],
        );

        final result = await repoImpl.getScholarships();

        expect(result, isA<Right<dynamic, List<Scholarship>>>());

        verify(() => remoteDataSrc.getScholarships()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.getScholarships()).thenThrow(tException);

        final result = await repoImpl.getScholarships();

        expect(
          result,
          Left<Failure, dynamic>(ServerFailure.fromException(tException)),
        );

        verify(() => remoteDataSrc.getScholarships()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
