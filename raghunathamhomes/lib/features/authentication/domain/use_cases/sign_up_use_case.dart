import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';
import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepo;
  SignUpUseCase(this.authRepo);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    return await authRepo.signUp(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      role: 'customer', 
    );
  }
}