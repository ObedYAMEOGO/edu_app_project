import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/domain/repos/category_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class GetCategories extends FutureUsecaseWithoutParams<List<Category>> {
  const GetCategories(this._repo);
  final CategoryRepo _repo;
  @override
  ResultFuture<List<Category>> call() async => _repo.getCategories();
}
