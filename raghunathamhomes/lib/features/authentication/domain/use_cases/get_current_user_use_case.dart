import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';
import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> execute() async {
    return await repository.getCurrentUser();
  }
}