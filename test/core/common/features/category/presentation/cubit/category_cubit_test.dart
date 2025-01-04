import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/add_category.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/get_categories.dart';
import 'package:edu_app_project/core/common/features/category/presentation/cubit/category_cubit.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCategory extends Mock implements AddCategory {}

class MockGetCategories extends Mock implements GetCategories {}

void main() {
  late AddCategory addCategory;
  late GetCategories getCategories;
  late CategoryCubit categoryCubit;

  final tCategory = Category(categoryId: '1', categoryTitle: 'Test Category');
  final tCategoryList = [tCategory];

  setUp(() {
    addCategory = MockAddCategory();
    getCategories = MockGetCategories();
    categoryCubit = CategoryCubit(
      addCategory: addCategory,
      getCategories: getCategories,
    );
    registerFallbackValue(tCategory);
  });

  tearDown(() {
    categoryCubit.close();
  });

  test(
    'initial state should be [CategoryInitial]',
    () async {
      expect(categoryCubit.state, const CategoryInitial());
    },
  );

  group('addCategory', () {
    blocTest<CategoryCubit, CategoryState>(
      'emits [AddingCategory, CategoryAdded] when addCategory is called successfully',
      build: () {
        when(() => addCategory(any()))
            .thenAnswer((_) async => const Right(null));
        return categoryCubit;
      },
      act: (cubit) => cubit.addCategory(tCategory),
      expect: () => const <CategoryState>[
        AddingCategory(),
        CategoryAdded(),
      ],
      verify: (_) {
        verify(() => addCategory(tCategory)).called(1);
        verifyNoMoreInteractions(addCategory);
      },
    );

    blocTest<CategoryCubit, CategoryState>(
      'emits [AddingCategory, CategoryError] when addCategory fails',
      build: () {
        when(() => addCategory(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return categoryCubit;
      },
      act: (cubit) => cubit.addCategory(tCategory),
      expect: () => const <CategoryState>[
        AddingCategory(),
        CategoryError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => addCategory(tCategory)).called(1);
        verifyNoMoreInteractions(addCategory);
      },
    );
  });

  group('getCategories', () {
    blocTest<CategoryCubit, CategoryState>(
      'emits [LoadingCategories, CategoriesLoaded] when getCategories is called successfully',
      build: () {
        when(() => getCategories())
            .thenAnswer((_) async => Right(tCategoryList));
        return categoryCubit;
      },
      act: (cubit) => cubit.getCategories(),
      expect: () => <CategoryState>[
        const LoadingCategories(),
        CategoriesLoaded(tCategoryList),
      ],
      verify: (_) {
        verify(() => getCategories()).called(1);
        verifyNoMoreInteractions(getCategories);
      },
    );

    blocTest<CategoryCubit, CategoryState>(
      'emits [LoadingCategories, CategoryError] when getCategories fails',
      build: () {
        when(() => getCategories()).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return categoryCubit;
      },
      act: (cubit) => cubit.getCategories(),
      expect: () => const <CategoryState>[
        LoadingCategories(),
        CategoryError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getCategories()).called(1);
        verifyNoMoreInteractions(getCategories);
      },
    );
  });
}
