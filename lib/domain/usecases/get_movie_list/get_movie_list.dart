import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/usecases/get_movie_list/get_movie_list_param.dart';

import '../../entities/movie/movie.dart';
import '../../entities/result/result.dart';
import '../usecase.dart';

class GetMovieList implements UseCase<Result<List<Movie>>, GetMovieListParam> {
  final MovieRepository _movieRepository;

  GetMovieList({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;

  @override
  Future<Result<List<Movie>>> call(GetMovieListParam params) async {
    final movieResult = switch (params.category) {
      MovieListCategories.nowPlaying =>
        await _movieRepository.getNowPlaying(page: params.page),
      MovieListCategories.upcoming =>
        await _movieRepository.getUpcoming(page: params.page)
    };

    return switch (movieResult) {
      Success(value: final movies) => Result.success(movies),
      Failed(:final message) => Result.failed(message)
    };
  }
}
