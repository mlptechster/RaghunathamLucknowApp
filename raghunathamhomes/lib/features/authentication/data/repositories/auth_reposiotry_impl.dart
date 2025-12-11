import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raghunathamhomes/features/authentication/data/models/user_model.dart';
import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';
import 'package:raghunathamhomes/utlis/exceptions/auth_exceptions.dart';
import 'package:raghunathamhomes/utlis/validator/email_password_validator.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper: parse createdAt/updatedAt that may be Timestamp or String or DateTime
  // DateTime _parseDate(dynamic value) {
  //   if (value == null) return DateTime.now();
  //   if (value is Timestamp) return value.toDate();
  //   if (value is DateTime) return value;
  //   if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  //   return DateTime.now();
  // }

  // --- SIGN UP ---
  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    String role = 'customer',
  }) async {
    try {
      final emailError = Validator.validateEmail(email);
      final passError = Validator.validatePassword(password);
      if (emailError != null) throw AuthException(emailError);
      if (passError != null) throw AuthException(passError);

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user?.uid ?? '';
      if (uid.isEmpty) throw AuthException('Failed to create user account.');

      // ⭐ ENHANCEMENT: Send verification email immediately
      await cred.user!.sendEmailVerification();

      // Create Firestore profile
      final now = DateTime.now();
      final userDoc = {
        'id': uid,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };
      await _firestore.collection('users').doc(uid).set(userDoc);

      return UserModel.fromJson(userDoc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? AuthException.fromCode(e.code).message);
    } on FirebaseException catch (e) {
      throw AuthException('Firestore error: ${e.message ?? e.code}');
    } catch (e) {
      throw AuthException('Unexpected error: $e');
    }
  }

  // --- LOGIN ---
  @override
Future<UserModel> login({
  required String email,
  required String password,
}) async {
  try {
    final emailError = Validator.validateEmail(email);
    final passError = Validator.validatePassword(password);
    if (emailError != null) throw AuthException(emailError);
    if (passError != null) throw AuthException(passError);

    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    final fbUser = cred.user;
    if (fbUser == null) throw AuthException('Login failed');

    if (!fbUser.emailVerified) {
      await fbUser.sendEmailVerification();
      await _auth.signOut();
      throw AuthException(
          'Email not verified. Verification email sent again.');
    }

    final uid = fbUser.uid;

    final doc =
        await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw AuthException('User profile not found in Firestore.');
    }

    return UserModel.fromJson(doc.data()!);
  } catch (e) {
    throw AuthException('Unexpected error during login: $e');
  }
}

  // --- GET CURRENT USER ---
  Future<UserModel?> getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!);
  } catch (e) {
    print('[AuthRepo] getCurrentUser error: $e');
    return null;
  }
}


  // --- SIGN OUT ---
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Logout failed. Please try again.');
    }
  }

  // 📧 IMPLEMENTATION: Forgot Password
  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final emailError = Validator.validateEmail(email);
      if (emailError != null) throw AuthException('Invalid email format.');
      
      await _auth.sendPasswordResetEmail(email: email);
      // Success is implied if no error is thrown
    } on FirebaseAuthException catch (e) {
      // Catch specific errors like 'user-not-found'
      throw AuthException(e.message ?? AuthException.fromCode(e.code).message);
    } catch (e) {
      throw AuthException('Failed to send password reset email: $e');
    }
  }

  // 📧 IMPLEMENTATION: Resend Email Verification
  @override
  Future<void> resendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException('No active user to send verification email to. Please log in.');
      }
      if (user.emailVerified) {
        throw AuthException('Your email is already verified!');
      }
      
      await user.sendEmailVerification();
      // Success is implied if no error is thrown
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? AuthException.fromCode(e.code).message);
    } catch (e) {
      throw AuthException('Failed to resend verification email: $e');
    }
  }
}