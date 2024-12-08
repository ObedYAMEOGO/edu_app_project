import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/forgot_password.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_in.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_out.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_up.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/update_user.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockSignOut extends Mock implements SignOut {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late MockSignIn signIn;
  late MockSignUp signUp;

  late MockSignOut signOut;

  late MockForgotPassword forgotPassword;
  late MockUpdateUser updateUser;
  late AuthBloc authBloc;

  const tPassword = 'password';
  const tEmail = 'email';
  const tFullName = 'fullName';
  const tUpdateUserAction = UpdateUserAction.password;
  const tUpdateUserParams = UpdateUserParams(
    action: tUpdateUserAction,
    userData: tPassword,
  );
  const tSignUpParams = SignUpParams(
    email: tEmail,
    password: tPassword,
    fullName: tFullName,
  );
  const tSignInParams = SignInParams(
    email: tEmail,
    password: tPassword,
  );

  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
  });

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    signOut = MockSignOut();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
      signOut: signOut,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test(
    'initialState should be AuthInitial',
    () async {
      expect(authBloc.state, const AuthInitial());
    },
  );

  const tServerFailure = ServerFailure(
    statusCode: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted.',
  );

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when SignInEvent is added '
      'and SignIn succeeds',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignInEvent(
          email: tEmail,
          password: tPassword,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedIn(user: tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when SignInEvent is added and '
      'SignIn fails',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignInEvent(
          email: tEmail,
          password: tPassword,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: '${tServerFailure.statusCode}: ${tServerFailure.message}',
        ),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when SignUpEvent is added '
      'and SignUp succeeds',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEvent(
          email: tEmail,
          password: tPassword,
          name: tFullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when SignUpEvent is added and '
      'SignUp fails',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEvent(
          email: tEmail,
          password: tPassword,
          name: tFullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: '${tServerFailure.statusCode}: ${tServerFailure.message}',
        ),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] when ForgotPasswordEvent '
      'is added and ForgotPassword succeeds',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(
          email: tEmail,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when ForgotPasswordEvent is added '
      'and ForgotPassword fails',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(
          email: tEmail,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: '${tServerFailure.statusCode}: ${tServerFailure.message}',
        ),
      ],
      verify: (_) {
        verify(() => forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when UpdateUserEvent is added '
      'and UpdateUser succeeds',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserAction,
          userData: tPassword,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when UpdateUserEvent is added and '
      'UpdateUser fails',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserAction,
          userData: tPassword,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: '${tServerFailure.statusCode}: ${tServerFailure.message}',
        ),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
