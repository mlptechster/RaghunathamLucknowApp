

import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase{
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call({required String email}) async {
    // The repository handles email validation and sending the Firebase email.
    return await repository.forgotPassword(email: email);
  }
}