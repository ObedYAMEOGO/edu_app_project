import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/domain/repos/exam_repo.dart';

class UpdateExam extends FutureUsecaseWithParams<void, Exam> {
  const UpdateExam(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<void> call(Exam params) => _repo.updateExam(params);
}
