import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/domain/repos/course_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class GetCourse extends FutureUsecaseWithParams<Course, String> {
  const GetCourse(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<Course> call(String params) async => _repo.getCourse(params);
}
