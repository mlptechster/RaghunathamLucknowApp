class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;

  factory AuthException.fromCode(String code) {
    switch (code.toLowerCase()) {
      // --- Standard Firebase codes ---
      case 'invalid-email':
        return AuthException('The email address is invalid.');
      case 'user-disabled':
        return AuthException('Your account has been disabled. Contact support.');
      case 'user-not-found':
        return AuthException('No account found for this email.');
      case 'wrong-password':
        return AuthException('Incorrect password.');
      case 'email-already-in-use':
        return AuthException('This email is already registered.');
      case 'weak-password':
        return AuthException('Password too weak. Use at least 8 characters with letters and digits.');
      case 'operation-not-allowed':
        return AuthException('Email/password sign-in is currently disabled.');

      // --- New Firebase v12+ codes ---
      case 'invalid_login_credentials':
      case 'invalid-credential':
      case 'invalid-credentials':
      case 'invalid_auth':
      case 'invalid-auth':
        return AuthException('Incorrect email or password.');

      case 'missing-password':
        return AuthException('Please enter your password.');
      case 'missing-email':
        return AuthException('Please enter your email address.');
      case 'network-request-failed':
        return AuthException('Network error. Check your connection and try again.');
      case 'too-many-requests':
        return AuthException('Too many attempts. Please try again later.');
      case 'internal-error':
        return AuthException('Internal error. Please try again later.');

      default:
        return AuthException('Authentication error. Please try again.');
    }
  }
}