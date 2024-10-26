import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUser usecase;
  const tAction = UpdateUserAction.displayName;
  const tUserData = 'User Test Data';
  late LocalUser tUser;
  setUp(() async {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    tUser = const LocalUser.empty();
  });
  test('should call [AuthRepo]', () async {
    registerFallbackValue(UpdateUserAction.displayName);
    // Arrange
    when(
      () => repo.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer((_) async => Right(tUser));
    // Act
    final result = await usecase(
      const UpdateUserParams(
        action: tAction,
        userData: tUserData,
      ),
    );
    // Assert
    expect(result, Right<dynamic, LocalUser>(tUser));
    verify(() => repo.updateUser(action: tAction, userData: tUserData))
        .called(1);
    verifyNoMoreInteractions(repo);
  });
}
