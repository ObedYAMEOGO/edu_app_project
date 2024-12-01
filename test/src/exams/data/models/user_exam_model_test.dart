import 'dart:convert';

import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/data/models/user_exam_model.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserExamModel = UserExamModel.empty(
    DateTime.fromMillisecondsSinceEpoch(1687187734940),
  );

  group('UserExamModel', () {
    test('should be a subclass of [UserExam] entity', () async {
      expect(tUserExamModel, isA<UserExam>());
    });

    group('fromMap', () {
      test('should return a valid [UserExamModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('user_exam.json')) as DataMap;
        final result = UserExamModel.fromMap(map);
        expect(result, tUserExamModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('user_exam.json')) as DataMap;
        final result = tUserExamModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [UserExamModel] with the same values',
          () async {
        final result = tUserExamModel.copyWith(examId: '');
        expect(result.examId, equals(''));
      });
    });
  });
}
