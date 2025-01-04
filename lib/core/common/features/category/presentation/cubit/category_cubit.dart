import 'package:bloc/bloc.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/add_category.dart';
import 'package:edu_app_project/core/common/features/category/domain/usecases/get_categories.dart';
import 'package:equatable/equatable.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required AddCategory addCategory,
    required GetCategories getCategories,
  })  : _addCategory = addCategory,
        _getCategories = getCategories,
        super(const CategoryInitial());
  final AddCategory _addCategory;
  final GetCategories _getCategories;

  Future<void> addCategory(Category category) async {
    emit(const AddingCategory());
    final result = await _addCategory(category);
    result.fold(
      (failure) => emit(CategoryError(failure.errorMessage)),
      (_) => emit(const CategoryAdded()),
    );
  }

  Future<void> getCategories() async {
    emit(const LoadingCategories());
    final result = await _getCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.errorMessage)),
      (courses) => emit(CategoriesLoaded(courses)),
    );
  }
}
