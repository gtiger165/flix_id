import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/entities/movie/movie.dart';
import 'package:flix_id/domain/entities/movie/movie_detail.dart';
import 'package:flix_id/domain/entities/result/result.dart';

abstract interface class MovieRepository {
  Future<Result<List<Movie>>> getNowPlaying({int page = 1});
  Future<Result<List<Movie>>> getUpcoming({int page = 1});
  Future<Result<MovieDetail>> getDetail({required int id});
  Future<Result<List<Actor>>> getActors({required int id});
}
