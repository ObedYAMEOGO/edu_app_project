import 'dart:convert';

import 'package:edu_app_project/core/common/features/materials/data/models/material_model.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  final tMaterialModel =
      MaterialModel.empty(DateTime.fromMillisecondsSinceEpoch(1687187734940));

  test(
    'should be a subclass of [Material] entity',
    () {
      expect(tMaterialModel, isA<Material>());
    },
  );
  final tMap = jsonDecode(fixture('material.json')) as DataMap;
  group('fromMap', () {
    test(
      'should return a [MaterialModel] with the correct data',
      () {
        final result = MaterialModel.fromMap(tMap);
        expect(result, equals(tMaterialModel));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a [Map] with the proper data',
      () async {
        final result = tMaterialModel.toMap();
        expect(result, equals(tMap));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a [MaterialModel] with the new data',
      () async {
        final result = tMaterialModel.copyWith(
          title: 'New Title',
        );

        expect(result.title, 'New Title');
      },
    );
  });
}
