import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/category/data/datasources/category_remote_data_source.dart';
import 'package:edu_app_project/core/common/features/category/data/models/category_model.dart';
import 'package:edu_app_project/core/common/features/category/data/repos/category_repo_impl.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRemoteDataSrc extends Mock
    implements CategoryRemoteDataSource {}

void main() {
  late CategoryRemoteDataSource remoteDataSource;
  late CategoryRepoImpl repoImpl;
  final tCategory = CategoryModel.empty();

  setUp(() {
    remoteDataSource = MockCategoryRemoteDataSrc();
    repoImpl = CategoryRepoImpl(remoteDataSource);
    registerFallbackValue(tCategory);
  });

  const tException = ServerException(
    message: 'Une erreur s\'est produite',
    statusCode: '500',
  );

  group('addCategory', () {
    test(
      'should complete successfully when we call to remote source is successful',
      () async {
        when(() => remoteDataSource.addCategory(any())).thenAnswer(
          (_) async => Future.value(),
        );
        final result = await repoImpl.addCategory(tCategory);
        expect(result, const Right<dynamic, void>(null));
        verify(() => remoteDataSource.addCategory(tCategory)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSource.addCategory(any())).thenThrow(tException);
        final result = await repoImpl.addCategory(tCategory);
        expect(
          result,
          Left<Failure, void>(ServerFailure.fromException(tException)),
        );
        verify(() => remoteDataSource.addCategory(tCategory)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getCategories', () {
    test(
      'should return [List<Categories>] when call to remote source is successful',
      () async {
        when(() => remoteDataSource.getCategories()).thenAnswer(
          (_) async => [tCategory],
        );
        final result = await repoImpl.getCategories();
        expect(result, isA<Right<dynamic, List<Category>>>());
        verify(() => remoteDataSource.getCategories()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSource.getCategories()).thenThrow(tException);
        final result = await repoImpl.getCategories();
        expect(
          result,
          Left<Failure, dynamic>(ServerFailure.fromException(tException)),
        );
        verify(() => remoteDataSource.getCategories()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
