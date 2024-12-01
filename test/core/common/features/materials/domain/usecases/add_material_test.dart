import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/usecases/get_materials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'material_repo.mock.dart';

void main() {
  late MockMaterialRepo repo;
  late GetMaterials usecase;

  const tCourseId = 'Test String';

  setUp(() {
    repo = MockMaterialRepo();
    usecase = GetMaterials(repo);
    registerFallbackValue(tCourseId);
  });

  test(
    'should return [List<Material>] from the repo',
    () async {
      when(
        () => repo.getMaterials(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right([]),
      );

      final result = await usecase(tCourseId);
      expect(result, equals(const Right<dynamic, List<Material>>([])));
      verify(
        () => repo.getMaterials(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
