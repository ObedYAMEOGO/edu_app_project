import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/repos/scholarship_repo.dart';

class GetScholarships extends FutureUsecaseWithoutParams<List<Scholarship>> {
  const GetScholarships(this._repo);
  final ScholarshipRepo _repo;

  @override
  ResultFuture<List<Scholarship>> call() async => _repo.getScholarships();
}
