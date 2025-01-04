import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/repos/category_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class AddCategory extends FutureUsecaseWithParams<void, Category> {
  const AddCategory(this._repo);
  final CategoryRepo _repo;

  @override
  ResultFuture<void> call(Category params) async => _repo.addCategory(params);
}
