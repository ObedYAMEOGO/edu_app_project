import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';

abstract class CategoryRepo {
  const CategoryRepo();

  ResultFuture<void> addCategory(Category category);
  ResultFuture<List<Category>> getCategories();
}
