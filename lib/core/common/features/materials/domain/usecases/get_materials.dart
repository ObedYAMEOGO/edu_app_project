import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/repos/material_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class GetMaterials extends FutureUsecaseWithParams<List<Material>, String> {
  const GetMaterials(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<List<Material>> call(String params) =>
      _repo.getMaterials(params);
}
