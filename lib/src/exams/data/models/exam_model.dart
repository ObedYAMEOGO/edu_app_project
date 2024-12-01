import 'dart:convert';

import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/data/models/exam_question_model.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam_question.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.courseId,
    required super.description,
    required super.title,
    required super.timeLimit,
    super.questions,
    super.imageUrl,
  });

  const ExamModel.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          title: 'Test String',
          description: 'Test String',
          timeLimit: 0,
          questions: const [],
        );

  factory ExamModel.fromJson(String source) =>
      ExamModel.fromMap(jsonDecode(source) as DataMap);

  ExamModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          title: map['title'] as String,
          description: map['description'] as String,
          timeLimit: (map['timeLimit'] as num).toInt(),
          imageUrl: map['imageUrl'] as String?,
          questions: null,
        );

  ExamModel.fromUploadMap(DataMap map)
      : this(
          id: map['id'] as String? ?? '',
          courseId: map['courseId'] as String? ?? '',
          title: map['title'] as String,
          description: map['Description'] as String,
          timeLimit: (map['time_seconds'] as num).toInt(),
          imageUrl: (map['image_url'] as String).isEmpty
              ? null
              : map['image_url'] as String,
          questions: List<DataMap>.from(map['questions'] as List<dynamic>)
              .map((questionData) {
            // add courseId to each question
            questionData['courseId'] = map['courseId'];
            return ExamQuestionModel.fromUploadMap(questionData);
          }).toList(),
        );

  ExamModel copyWith({
    String? id,
    String? courseId,
    List<ExamQuestion>? questions,
    String? title,
    String? description,
    int? timeLimit,
    String? imageUrl,
  }) {
    return ExamModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      questions: questions ?? this.questions,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // We never actually upload the questions with the exam, so we don't need to
  // convert them to a map. Instead we will keep them in individual
  // documents, and at the point of taking the exam, we will fetch the questions
  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => jsonEncode(toMap());
}
