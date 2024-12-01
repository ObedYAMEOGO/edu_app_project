import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/repos/scholarship_repo.dart';

class AddScholarship extends FutureUsecaseWithParams<void, Scholarship> {
  const AddScholarship(this._repo);
  final ScholarshipRepo _repo;

  @override
  ResultFuture<void> call(Scholarship params) async =>
      _repo.addScholarship(params);
}
