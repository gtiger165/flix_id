import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:flix_id/domain/usecases/register/register_param.dart';

import '../../entities/result/result.dart';
import '../usecase.dart';

class Register implements UseCase<Result<User>, RegisterParam> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  Register(
      {required Authentication authentication,
      required UserRepository userRepository})
      : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(RegisterParam params) async {
    final uidResult = await _authentication.register(
        email: params.email, password: params.password);

    if (uidResult.isFailed) {
      return Result.failed(uidResult.errorMessage!);
    }

    final userResult = await _userRepository.createUser(
      uid: uidResult.resultValue!,
      email: params.email,
      name: params.name,
      photoUrl: params.photoUrl,
    );

    if (userResult.isFailed) {
      return Result.failed(userResult.errorMessage!);
    }

    return Result.success(userResult.resultValue!);
  }
}
