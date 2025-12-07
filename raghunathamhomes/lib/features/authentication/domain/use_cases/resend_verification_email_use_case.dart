

import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';

class ResendEmailVerificationUseCase{
  final AuthRepository repository;

  ResendEmailVerificationUseCase(this.repository);

  Future<void> call() async {
    // This method relies on the repository checking for an active user session.
    return await repository.resendEmailVerification();
  }
}