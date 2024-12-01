import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/common/features/materials/data/models/material_model.dart';
import 'package:edu_app_project/core/common/features/materials/domain/usecases/add_material.dart';
import 'package:edu_app_project/core/common/features/materials/domain/usecases/get_materials.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:edu_app_project/core/errors/failures.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddMaterial extends Mock implements AddMaterial {}

class MockGetMaterials extends Mock implements GetMaterials {}

void main() {
  late AddMaterial addMaterial;
  late GetMaterials getMaterials;
  late MaterialCubit materialCubit;

  final tMaterial = MaterialModel.empty();

  setUp(() {
    addMaterial = MockAddMaterial();
    getMaterials = MockGetMaterials();
    materialCubit = MaterialCubit(
      addMaterial: addMaterial,
      getMaterials: getMaterials,
    );
    registerFallbackValue(tMaterial);
  });

  tearDown(() {
    materialCubit.close();
  });

  test(
    'initial state should be [MaterialInitial]',
    () async {
      expect(materialCubit.state, const MaterialInitial());
    },
  );

  group('addMaterial', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialsAdded] when addMaterial is called',
      build: () {
        when(() => addMaterial(any()))
            .thenAnswer((_) async => const Right(null));
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterials([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterials(),
        MaterialsAdded(),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialError] when '
      'addMaterial is called and fails',
      build: () {
        when(() => addMaterial(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server Failure', statusCode: 500),
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterials([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterials(),
        MaterialError('500 Error: Server Failure'),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );
  });

  group('getMaterials', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [LoadingMaterials, MaterialsLoaded] when getMaterials is called',
      build: () {
        when(() => getMaterials(any()))
            .thenAnswer((_) async => const Right([]));
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterials('testId'),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialsLoaded([]),
      ],
      verify: (_) {
        verify(() => getMaterials('testId')).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [LoadingMaterials, MaterialError] when getMaterials '
      'is called and fails',
      build: () {
        when(() => getMaterials(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server Failure', statusCode: 500),
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterials('testId'),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialError('500 Error: Server Failure'),
      ],
      verify: (_) {
        verify(() => getMaterials('testId')).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );
  });
}
