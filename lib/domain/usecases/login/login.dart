import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import '../usecase.dart';

part 'login_params.dart';

class Login implements UseCase<Result<User>, LoginParams> {
  final Authentication authentication;
  final UserRepository repository;

  Login({required this.authentication, required this.repository});

  @override
  Future<Result<User>> call(LoginParams params) async {
    final idResult = await authentication.login(
        email: params.email, password: params.password);

    if (idResult is! Success) {
      return Result.failed(idResult.errorMessage!);
    }

    final userResult = await repository.getUser(uid: idResult.resultValue!);

    return switch (userResult) {
      Success(value: final user) => Result.success(user),
      Failed(:final message) => Result.failed(message)
    };
  }
}
