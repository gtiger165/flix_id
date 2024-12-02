import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../entities/user/user.dart';

class GetLoggedInUser implements UseCase<Result<User>, void> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  GetLoggedInUser({
    required Authentication authentication,
    required UserRepository userRepository,
  })  : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(void _) async {
    String? loggedId = _authentication.getLoggedInUserId();

    if (loggedId == null) {
      return Result.failed("No user logged in");
    }

    final userResult = await _userRepository.getUser(uid: loggedId);

    if (userResult.isFailed) {
      return Result.failed(userResult.errorMessage!);
    }

    return Result.success(userResult.resultValue!);
  }
}
