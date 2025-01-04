part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class LoadingCategories extends CategoryState {
  const LoadingCategories();
}

class AddingCategory extends CategoryState {
  const AddingCategory();
}

class CategoryAdded extends CategoryState {
  const CategoryAdded();
}

class CategoriesLoaded extends CategoryState {
  const CategoriesLoaded(this.categories);

  final List<Category> categories;

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  const CategoryError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
