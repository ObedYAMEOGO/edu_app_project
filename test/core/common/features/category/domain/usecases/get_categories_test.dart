import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/repos/category_repo.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/get_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'category_repo.mock.dart';

void main() {
  late CategoryRepo repo;
  late GetCategories usecase;

  setUp(() {
    repo = MockCategoryRepo();
    usecase = GetCategories(repo);
  });

  test('should get categories from the repo', () async {
    when(() => repo.getCategories()).thenAnswer((_) async => const Right([]));
    final result = await usecase();
    expect(result, const Right<dynamic, List<Category>>([]));
    verify(() => repo.getCategories()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
