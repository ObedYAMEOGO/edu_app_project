import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:edu_app_project/src/exams/domain/repos/exam_repo.dart';

class SubmitExam extends FutureUsecaseWithParams<void, UserExam> {
  const SubmitExam(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<void> call(UserExam params) => _repo.submitExam(params);
}
