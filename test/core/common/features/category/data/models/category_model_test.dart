import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/core/common/features/category/data/models/category_model.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  const tCategoryModel = CategoryModel(
    categoryId: '1',
    categoryTitle: 'Test Category',
    categoryImage: 'Test Image',
    isImageFile: false,
    categoryCourseIds: ['1', '2'],
  );

  group('CategoryModel', () {
    test('should be a subclass of Category entity', () {
      expect(tCategoryModel, isA<Category>());
    });
  });

  group('fromMap', () {
    test(
      'should return a valid [CategoryModel] from a valid map',
      () async {
        final map = jsonDecode(fixture('category.json')) as DataMap;

        final result = CategoryModel.fromMap(map);

        expect(result, isA<CategoryModel>());
        expect(result, equals(tCategoryModel));
      },
    );
    test(
      'should throw a [Error] when the map is invalid',
      () async {
        final map = jsonDecode(fixture('category.json')) as DataMap
          ..remove('categoryId');

        final secondMap = jsonDecode(fixture('category.json')) as DataMap
          ..update('categoryId', (value) => 1);

        const call = CategoryModel.fromMap;

        expect(() => call(map), throwsA(isA<Error>()));
        expect(() => call(secondMap), throwsA(isA<Error>()));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid [DataMap] from a valid [CategoryModel]',
      () async {
        final result = tCategoryModel.toMap();

        expect(result, equals(jsonDecode(fixture('category.json'))));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a valid [CategoryModel] with updated values',
      () async {
        final result = tCategoryModel.copyWith(categoryId: '2');

        expect(result, isA<CategoryModel>());
        expect(result.categoryId, '2');
      },
    );
  });
}
