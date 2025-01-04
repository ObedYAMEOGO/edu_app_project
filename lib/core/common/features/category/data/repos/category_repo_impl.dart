import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/category/data/datasources/category_remote_data_source.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/repos/category_repo.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class CategoryRepoImpl implements CategoryRepo {
  const CategoryRepoImpl(this._remoteDataSrc);
  final CategoryRemoteDataSource _remoteDataSrc;

  @override
  ResultFuture<void> addCategory(Category category) async {
    try {
      await _remoteDataSrc.addCategory(category);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Category>> getCategories() async {
    try {
      final categories = await _remoteDataSrc.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
