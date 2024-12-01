import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/materials/data/datasources/material_remote_data_src.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/repos/material_repo.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class MaterialRepoImpl implements MaterialRepo {
  const MaterialRepoImpl(this._remoteDataSource);

  final MaterialRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Material>> getMaterials(String courseId) async {
    try {
      final result = await _remoteDataSource.getMaterials(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addMaterial(Material material) async {
    try {
      await _remoteDataSource.addMaterial(material);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
