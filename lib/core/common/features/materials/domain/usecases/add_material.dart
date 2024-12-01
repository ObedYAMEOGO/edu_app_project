import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/repos/material_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class AddMaterial extends FutureUsecaseWithParams<void, Material> {
  const AddMaterial(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<void> call(Material params) => _repo.addMaterial(params);
}
