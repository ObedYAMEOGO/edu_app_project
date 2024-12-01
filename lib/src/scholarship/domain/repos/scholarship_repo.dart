

import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';

abstract class ScholarshipRepo {
  const ScholarshipRepo();

  ResultFuture<List<Scholarship>> getScholarships();
  ResultFuture<void> addScholarship(Scholarship scholarship);
}
