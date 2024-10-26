import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword usecase;
  const tEmail = 'Test email';
  setUp(() async {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });
  test('should call the [AuthRepo.forgotPassword]', () async {
    // Arrange
    when(() => repo.forgotPassword(any()))
        .thenAnswer((_) async => const Right(null));
    // Act
    final result = await usecase(tEmail);
    // Assert
    expect(result, const Right<void, dynamic>(null));
    verify(() => repo.forgotPassword(tEmail)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
