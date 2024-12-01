import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam_question.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';

abstract class ExamRepo {
  ResultFuture<List<Exam>> getExams(String courseId);

  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam);

  ResultFuture<void> uploadExam(Exam exam);

  ResultFuture<void> updateExam(Exam exam);

  // In the users collection, a user will have a collection of exams taken
  // in that collection, when a user completes an exam, the exam will be
  // added with their answers, then finally we add the score to the exam to
  // the user's own points

  ResultFuture<void> submitExam(UserExam exam);

  ResultFuture<List<UserExam>> getUserExams();

  ResultFuture<List<UserExam>> getUserCourseExams(String courseId);
}
