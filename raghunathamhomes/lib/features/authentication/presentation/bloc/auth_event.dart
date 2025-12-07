// features/authentication/presentation/bloc/auth_event.dart

import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthSignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  AuthSignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}

class AuthSignOutRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});
}

class AuthResendVerificationEmailRequested extends AuthEvent {}

// For checking session on app startup
class AuthCheckStatusRequested extends AuthEvent {}