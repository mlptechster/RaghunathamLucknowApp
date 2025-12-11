import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/forgot_password_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/get_current_user_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/log_out_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/resend_verification_email_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/sign_up_use_case.dart';
import 'package:raghunathamhomes/utlis/exceptions/auth_exceptions.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResendEmailVerificationUseCase resendEmailVerificationUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.signOutUserUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.resendEmailVerificationUseCase,
  }) : super(AuthState.initial()) {
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResendVerificationEmailRequested>(_onResendVerificationEmailRequested);
    on<AuthCheckEmailVerificationRequested>(_onCheckEmailVerificationRequested);
  }

  // --- HANDLERS ---

  Future<void> _onCheckStatusRequested(
      AuthCheckStatusRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ));
      }
    } catch (_) {
      // In case of any unexpected error during check, default to unauthenticated
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        isLoading: false,
      ));
    }
  }
  Future<void> _onCheckEmailVerificationRequested(
      AuthCheckEmailVerificationRequested event, Emitter<AuthState> emit) async {
    try {
      final user = await getCurrentUserUseCase.execute();
      
      if (user != null) {
        // User is verified and profile is loaded. Emit the authenticated state.
        // Crucially, we must reset the messages (errorMessage/successMessage) 
        // to ensure the state is distinct from the previous 'requiresEmailVerification' state.
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          // Clear messages to ensure state transition is clean
          errorMessage: null, 
          successMessage: 'Welcome home!', // Optional success message on auto-login
          isLoading: false,
        ));
      } 
      // If user is null, the state remains requiresEmailVerification, and the timer continues.
    } catch (e) {
      print('Periodic verification check error: $e'); 
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await loginUseCase.call(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        successMessage: 'Login successful!',
      ));
    } on AuthException catch (e) {
      // Handle the specific error thrown by the repository
      if (e.message.contains('not verified')) {
        // Special state for verification flow
        emit(state.copyWith(
          status: AuthStatus.requiresEmailVerification,
          errorMessage: e.message,
          isLoading: false,
        ));
      } else {
        // General login error
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.message,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'An unexpected error occurred during login: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await signUpUseCase.call(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
      );
      // User is created but must verify email, so we emit the specific status
      emit(state.copyWith(
        status: AuthStatus.requiresEmailVerification,
        user: user,
        successMessage: 'Account created! Please check your email to verify.',
        isLoading: false,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'An unexpected error occurred during sign up: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await signOutUserUseCase.call();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        successMessage: 'Successfully logged out.',
        isLoading: false,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'An unexpected error occurred during sign out.',
        isLoading: false,
      ));
    }
  }

  Future<void> _onForgotPasswordRequested(
      AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await forgotPasswordUseCase.call(email: event.email);
      emit(state.copyWith(
        successMessage: 'Password reset link sent to ${event.email}!',
        isLoading: false,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to send reset link.',
        isLoading: false,
      ));
    }
  }

  Future<void> _onResendVerificationEmailRequested(
      AuthResendVerificationEmailRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await resendEmailVerificationUseCase.call();
      emit(state.copyWith(
        successMessage: 'Verification email resent successfully.',
        isLoading: false,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to resend verification email.',
        isLoading: false,
      ));
    }
  }
}