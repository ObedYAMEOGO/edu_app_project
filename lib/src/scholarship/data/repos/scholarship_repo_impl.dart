import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/data/datasources/scholarship_remote_data_source.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/repos/scholarship_repo.dart';

class ScholarshipRepoImpl implements ScholarshipRepo {
  const ScholarshipRepoImpl(this._remoteDataSrc);

  final ScholarshipRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addScholarship(Scholarship scholarship) async {
    try {
      await _remoteDataSrc.addScholarship(scholarship);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Scholarship>> getScholarships() async {
    try {
      final scholarships = await _remoteDataSrc.getScholarships();
      return Right(scholarships);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
