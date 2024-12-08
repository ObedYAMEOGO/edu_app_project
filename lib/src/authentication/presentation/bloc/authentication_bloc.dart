import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/forgot_password.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_in.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_up.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/update_user.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_out.dart'; // Import the SignOut use case
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
    required SignOut signOut,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<SignOutEvent>(_signOutHandler); // Add event handler for SignOutEvent
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
  final SignOut _signOut; // Declare SignOut use case

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) =>
          emit(AuthError(message: '${failure.statusCode}: ${failure.message}')),
      (user) => emit(SignedIn(user: user as LocalUserModel)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.name,
      ),
    );
    result.fold(
      (failure) =>
          emit(AuthError(message: '${failure.statusCode}: ${failure.message}')),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(event.email);
    result.fold(
      (failure) =>
          emit(AuthError(message: '${failure.statusCode}: ${failure.message}')),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );
    result.fold(
      (failure) =>
          emit(AuthError(message: '${failure.statusCode}: ${failure.message}')),
      (_) => emit(const UserUpdated()),
    );
  }

  Future<void> _signOutHandler(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _signOut();
      emit(const LoggedOut());
    } catch (e) {
      emit(AuthError(
          message: "Erreur lors de la déconnexion : ${e.toString()}"));
    }
  }
}
