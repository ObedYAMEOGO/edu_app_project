import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam_question.dart';
import 'package:edu_app_project/src/exams/domain/repos/exam_repo.dart';

class GetExamQuestions
    extends FutureUsecaseWithParams<List<ExamQuestion>, Exam> {
  const GetExamQuestions(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<List<ExamQuestion>> call(Exam params) =>
      _repo.getExamQuestions(params);
}
