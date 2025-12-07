

import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';

abstract class AuthRepository {
  // Existing methods
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    String role = 'customer',
  });

  Future<UserEntity> login({
    required String email,
    required String password,
  });
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();

  // ⭐ NEW: Forgot Password method
  Future<void> forgotPassword({required String email});
  
  // ⭐ NEW: Resend Email Verification method (useful for UI)
  Future<void> resendEmailVerification();
}