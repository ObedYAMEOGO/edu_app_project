import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/user/data/datasources/user_remote_data_source.dart';
import 'package:edu_app_project/core/common/features/user/domain/repos/user_repo.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';

class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> addPoints({
    required String userId,
    required int points,
  }) async {
    try {
      await _remoteDataSource.addPoints(userId: userId, points: points);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<LocalUser> getUserById(String userId) async {
    try {
      final result = await _remoteDataSource.getUserById(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
