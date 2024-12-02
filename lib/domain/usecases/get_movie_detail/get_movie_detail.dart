import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/movie/movie_detail.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/get_movie_detail/get_movie_detail_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetMovieDetail
    implements UseCase<Result<MovieDetail>, GetMovieDetailParam> {
  final MovieRepository _repository;

  GetMovieDetail({required MovieRepository repository})
      : _repository = repository;

  @override
  Future<Result<MovieDetail>> call(GetMovieDetailParam params) async {
    final result = await _repository.getDetail(id: params.movie.id);

    return switch (result) {
      Success(value: final movieDetail) => Result.success(movieDetail),
      Failed(:final message) => Result.failed(message)
    };
  }
}
