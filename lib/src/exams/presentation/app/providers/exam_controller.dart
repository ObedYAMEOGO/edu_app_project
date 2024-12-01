import 'dart:async';

import 'package:edu_app_project/src/exams/data/models/user_choice_model.dart';
import 'package:edu_app_project/src/exams/data/models/user_exam_model.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam_question.dart';
import 'package:edu_app_project/src/exams/domain/entities/question_choice.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_choice.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:flutter/foundation.dart';

class ExamController extends ChangeNotifier {
  ExamController({required Exam exam})
      : _exam = exam,
        _questions = exam.questions! {
    _userExam = UserExamModel(
      examId: exam.id,
      courseId: exam.courseId,
      examTitle: exam.title,
      examImageUrl: exam.imageUrl,
      totalQuestions: exam.questions!.length,
      dateSubmitted: DateTime.now(),
      answers: const [],
    );
    _remainingTime = exam.timeLimit;
  }

  final List<ExamQuestion> _questions;

  final Exam _exam;

  Exam get exam => _exam;

  int get totalQuestions => _questions.length;

  late int _remainingTime;

  bool get isTimeUp => _remainingTime == 0;

  int get remainingTimeInSeconds => _remainingTime;

  bool _examStarted = false;

  bool get examStarted => _examStarted;

  String get remainingTime {
    final minutes = _remainingTime ~/ 60;
    final seconds = _remainingTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  late UserExam _userExam;

  UserExam get userExam => _userExam;

  Timer? _timer;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  ExamQuestion get currentQuestion => _questions[_currentIndex];

  void startTimer() {
    _examStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  UserChoice? get userAnswer {
    final answers = _userExam.answers;
    var noAnswer = false;
    final questionId = currentQuestion.id;
    final userChoice = answers.firstWhere(
      (answer) => answer.questionId == questionId,
      orElse: () {
        noAnswer = true;
        return const UserChoiceModel.empty();
      },
    );
    return noAnswer ? null : userChoice;
  }

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextQuestion() {
    if (!_examStarted) startTimer();
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void answer(QuestionChoice choice) {
    if (!_examStarted && _currentIndex == 0) startTimer();
    final answers = List<UserChoice>.of(_userExam.answers);
    final userChoice = UserChoiceModel(
      questionId: choice.questionId,
      correctChoice: currentQuestion.correctAnswer!,
      userChoice: choice.identifier,
    );
    if (answers.any((answer) => answer.questionId == userChoice.questionId)) {
      final index = answers.indexWhere(
        (answer) => answer.questionId == userChoice.questionId,
      );
      answers[index] = userChoice;
      debugPrint('Answer changed');
      debugPrint('Answer: ${answers[index].userChoice}');
      debugPrint('Answers: $answers');
    } else {
      answers.add(userChoice);
      debugPrint('Answer added');
      debugPrint('Answer: ${answers.last.userChoice}');
      debugPrint('Answers: $answers');
    }
    _userExam = (_userExam as UserExamModel).copyWith(answers: answers);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
