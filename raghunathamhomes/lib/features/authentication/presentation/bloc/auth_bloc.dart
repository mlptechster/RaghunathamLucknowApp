import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/features/authentication/data/models/user_model.dart';
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
        final fbUser = FirebaseAuth.instance.currentUser;
        if (fbUser != null && !fbUser.emailVerified) {
          emit(state.copyWith(
            status: AuthStatus.requiresEmailVerification,
            user: user,
            isLoading: false,
          ));
        } else {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isLoading: false,
          ));
        }
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        isLoading: false,
      ));
    }
  }
   Future<void> _onCheckEmailVerificationRequested(
      AuthCheckEmailVerificationRequested event,
      Emitter<AuthState> emit) async {
    try {
      final fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser == null) return;

      await fbUser.reload(); // 🔑 refresh user

      if (fbUser.emailVerified) {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(fbUser.uid).get();
        if (!doc.exists) return;

        final user = UserModel.fromJson(doc.data()!);

        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          successMessage: 'Email verified! Welcome.',
          errorMessage: null,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.requiresEmailVerification,
          isLoading: false,
        ));
      }
    } catch (e) {
      print('[AuthBloc] Email verification check error: $e');
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

      final fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser != null && !fbUser.emailVerified) {
        emit(state.copyWith(
          status: AuthStatus.requiresEmailVerification,
          user: user,
          errorMessage: 'Email not verified. Please check your inbox.',
          isLoading: false,
        ));
        return;
      }

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        successMessage: 'Login successful!',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
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

      // ✅ Do NOT authenticate immediately. Go to verification screen.
      emit(state.copyWith(
        status: AuthStatus.requiresEmailVerification,
        user: user,
        successMessage: 'Account created! Please verify your email.',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
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