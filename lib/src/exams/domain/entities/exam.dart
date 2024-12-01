import 'package:edu_app_project/src/exams/domain/entities/exam_question.dart';
import 'package:equatable/equatable.dart';

// firebase path => courses >> course_id >> exams >> exam_id >> questions
// >> questionDoc

// courses >> course_id >> exams >> exam_id >> answers >> question_id
// > answerDoc

class Exam extends Equatable {
  const Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    this.questions,
    this.imageUrl,
  });

  const Exam.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          title: 'Test String',
          description: 'Test String',
          timeLimit: 0,
          questions: const [],
        );

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final int timeLimit;
  final List<ExamQuestion>? questions;

  @override
  List<Object?> get props => [id, courseId];
}
