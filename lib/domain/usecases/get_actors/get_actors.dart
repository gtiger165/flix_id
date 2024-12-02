import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/get_actors/get_actors_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetActors implements UseCase<Result<List<Actor>>, GetActorsParam> {
  final MovieRepository _repository;

  GetActors({required MovieRepository repository}) : _repository = repository;

  @override
  Future<Result<List<Actor>>> call(GetActorsParam params) async {
    final result = await _repository.getActors(id: params.movieId);

    return switch (result) {
      Success(value: final actors) => Result.success(actors),
      Failed(:final message) => Result.failed(message)
    };
  }
}
