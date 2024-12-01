import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  final timestamp = Timestamp.fromDate(date);

  final tMap = jsonDecode(fixture('scholarship.json')) as DataMap;
  tMap['applicationDeadline'] = timestamp;
  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;

  final tScholarshipModel = ScholarshipModel.fromMap(tMap);

  test('should be a subclass of Scholarship entity', () {
    expect(tScholarshipModel, isA<Scholarship>());
  });

  group('empty', () {
    test('should return a ScholarshipModel with empty data', () {
      final result = ScholarshipModel.empty();
      expect(result.name, '_empty.name');
    });
  });

  group('fromMap', () {
    test(
      'should return a ScholarshipModel with the correct data',
      () {
        final result = ScholarshipModel.fromMap(tMap);
        expect(result, equals(tScholarshipModel));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a Map with the proper data',
      () async {
        final result = tScholarshipModel.toMap()
          ..remove('applicationDeadline')
          ..remove('createdAt')
          ..remove('updatedAt');

        final map = DataMap.from(tMap)
          ..remove('applicationDeadline')
          ..remove('createdAt')
          ..remove('updatedAt');
        expect(result, equals(map));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a ScholarshipModel with the new data',
      () async {
        final result = tScholarshipModel.copyWith(
          name: 'New Name',
        );

        expect(result.name, 'New Name');
      },
    );
  });
}
