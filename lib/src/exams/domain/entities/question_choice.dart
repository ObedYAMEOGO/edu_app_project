import 'package:equatable/equatable.dart';

class QuestionChoice extends Equatable {
  const QuestionChoice({
    required this.identifier,
    required this.choiceAnswer,
    required this.questionId,
  });

  final String questionId;
  final String identifier;
  final String choiceAnswer;

  @override
  List<Object?> get props => [questionId, identifier, choiceAnswer];
}
