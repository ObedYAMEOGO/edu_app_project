import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;
  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tFullName = 'Test fullname';
  setUp(() async {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });
  const tUser = LocalUser.empty();
  test('should call [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(tUser));
    // Act
    final result = await usecase(
      const SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );
    // Assert
    expect(result, const Right<dynamic, LocalUser>(tUser));
    verify(
      () => repo.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
