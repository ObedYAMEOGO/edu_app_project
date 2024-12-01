import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/materials/data/datasources/material_remote_data_src.dart';
import 'package:edu_app_project/core/common/features/materials/data/models/material_model.dart';
import 'package:edu_app_project/core/common/features/materials/data/repos/material_repo_impl.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMaterialRemoteDataSrc extends Mock implements MaterialRemoteDataSrc {}

void main() {
  late MaterialRemoteDataSrc remoteDataSource;
  late MaterialRepoImpl repoImpl;

  final tMaterial = MaterialModel.empty();

  setUp(() {
    remoteDataSource = MockMaterialRemoteDataSrc();
    repoImpl = MaterialRepoImpl(remoteDataSource);
    registerFallbackValue(tMaterial);
  });

  const tException = ServerException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addMaterial', () {
    test(
      'should complete successfully when call to remote source is '
      'successful',
      () async {
        when(() => remoteDataSource.addMaterial(any())).thenAnswer(
          (_) async => Future.value(),
        );

        final result = await repoImpl.addMaterial(tMaterial);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSource.addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSource.addMaterial(any())).thenThrow(tException);

        final result = await repoImpl.addMaterial(tMaterial);

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(tException),
            ),
          ),
        );

        verify(() => remoteDataSource.addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getMaterials', () {
    test(
      'should complete successfully when call to remote source is '
      'successful',
      () async {
        when(() => remoteDataSource.getMaterials(any())).thenAnswer(
          (_) async => [tMaterial],
        );

        final result = await repoImpl.getMaterials('courseId');

        expect(result, isA<Right<dynamic, List<Material>>>());

        verify(() => remoteDataSource.getMaterials('courseId')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSource.getMaterials(any())).thenThrow(tException);

        final result = await repoImpl.getMaterials('courseId');

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(tException),
            ),
          ),
        );

        verify(() => remoteDataSource.getMaterials('courseId')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
