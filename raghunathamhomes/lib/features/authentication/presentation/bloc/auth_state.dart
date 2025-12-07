// features/authentication/presentation/bloc/auth_state.dart

import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  requiresEmailVerification,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage; // For user-friendly feedback

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  // Helper method to create new states based on the current one
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? false,
      // Use null to clear messages
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  // Initial state is unknown
  factory AuthState.initial() => const AuthState();
}