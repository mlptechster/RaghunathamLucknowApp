import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';
import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';

class LoginUseCase{
  final AuthRepository authRepo;
  LoginUseCase(this.authRepo);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await authRepo.login(email: email, password: password);
  }
}