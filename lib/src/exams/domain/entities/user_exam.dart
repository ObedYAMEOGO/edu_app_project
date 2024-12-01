import 'package:edu_app_project/src/exams/domain/entities/user_choice.dart';
import 'package:equatable/equatable.dart';

// users >> userId >> courses >> courseId >> exams >> examId >> answers
/// So the plan is, even when we want to display the user's exam history, we
/// can fetch the actual exam by the [examId] and then display the questions,
/// then we can make the radio buttons disabled or enabled depending on the
/// [answers.firstWhere((answer) => answer.questionId == questionId).choiceId]
// ignore: comment_references
/// being equal to the [choiceId] of the radio button
class UserExam extends Equatable {
  const UserExam({
    required this.examId,
    required this.courseId,
    required this.answers,
    required this.totalQuestions,
    required this.examTitle,
    required this.dateSubmitted,
    this.examImageUrl,
  });

  UserExam.empty([DateTime? date])
      : this(
          examId: 'Test String',
          courseId: 'Test String',
          totalQuestions: 0,
          examTitle: 'Test String',
          examImageUrl: 'Test String',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  final String examId;
  final String courseId;
  final int totalQuestions;
  final String examTitle;
  final String? examImageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> answers;

  @override
  List<Object?> get props => [examId, courseId];
}
