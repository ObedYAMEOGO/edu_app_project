import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/usecases/add_material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'material_repo.mock.dart';

void main() {
  late MockMaterialRepo repo;
  late AddMaterial usecase;

  final tMaterial = Material.empty();

  setUp(() {
    repo = MockMaterialRepo();
    usecase = AddMaterial(repo);
    registerFallbackValue(tMaterial);
  });

  test(
    'should call the [MaterialRepo.addMaterial]',
    () async {
      when(
        () => repo.addMaterial(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(tMaterial);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addMaterial(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
