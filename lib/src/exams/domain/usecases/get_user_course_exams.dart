import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:edu_app_project/src/exams/domain/repos/exam_repo.dart';

class GetUserCourseExams
    extends FutureUsecaseWithParams<List<UserExam>, String> {
  const GetUserCourseExams(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<List<UserExam>> call(String params) =>
      _repo.getUserCourseExams(params);
}
