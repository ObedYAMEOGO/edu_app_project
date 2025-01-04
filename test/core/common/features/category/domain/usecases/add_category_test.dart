import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/repos/category_repo.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/add_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'category_repo.mock.dart';

void main() {
  late CategoryRepo repo;
  late AddCategory usecase;

  final tCategory = Category.empty();

  setUp(() {
    repo = MockCategoryRepo();
    usecase = AddCategory(repo);
    registerFallbackValue(tCategory);
  });

  test(
    'should call [CategoryRepo.addCategory]',
    () async {
      when(() => repo.addCategory(any()))
          .thenAnswer((_) async => const Right(null));
      await usecase.call(tCategory);
      verify(() => repo.addCategory(tCategory)).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
