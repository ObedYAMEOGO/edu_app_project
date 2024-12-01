import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

abstract class MaterialRepo {
  const MaterialRepo();

  ResultFuture<List<Material>> getMaterials(String courseId);

  ResultFuture<void> addMaterial(Material material);
}
