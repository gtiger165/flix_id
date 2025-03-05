import 'package:dio/dio.dart';
import 'package:flix_id/data/TMDB/tmdb_movie_repository.dart';
import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/entities/movie/movie.dart';
import 'package:flix_id/domain/entities/movie/movie_detail.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('TmdbMovieRepository', () {
    late TmdbMovieRepository repository;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      repository = TmdbMovieRepository(dio: mockDio);
    });

    setUpAll(() {
      registerFallbackValue(RequestOptions());
    });

    test('getNowPlaying - Success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: {
                  'results': [
                    {'id': 1, 'title': 'Movie 1'},
                    {'id': 2, 'title': 'Movie 2'}
                  ]
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await repository.getNowPlaying();

      expect(result, isA<Result<List<Movie>>>());
      expect(result.resultValue!.length, 2);
      expect(result.resultValue![0].id, 1);
      expect(result.resultValue![1].title, 'Movie 2');
    });

    test('getNowPlaying - DioException', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getNowPlaying();

      expect(result, isA<Result<List<Movie>>>());
      expect(result.errorMessage, isA<String>());
    });

    test('getUpcoming - Success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: {
                  'results': [
                    {'id': 3, 'title': 'Movie 3'}
                  ]
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await repository.getUpcoming();

      expect(result, isA<Result<List<Movie>>>());
      expect(result.resultValue!.length, 1);
      expect(result.resultValue![0].id, 3);
    });

    test('getDetail - Success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: {'id': 4, 'title': 'Movie Detail'},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await repository.getDetail(id: 4);

      expect(result, isA<Result<MovieDetail>>());
      expect(result.resultValue!.id, 4);
      expect(result.resultValue!.title, 'Movie Detail');
    });

    test('getDetail - DioException', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getDetail(id: 4);

      expect(result, isA<Result<MovieDetail>>());
      expect(result.errorMessage, isA<String>());
    });

    test('getActors - Success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: {
                  'cast': [
                    {'id': 5, 'name': 'Actor 1'},
                    {'id': 6, 'name': 'Actor 2'}
                  ]
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await repository.getActors(id: 5);

      expect(result, isA<Result<List<Actor>>>());
      expect(result.resultValue!.length, 2);
      expect(result.resultValue![1].name, 'Actor 2');
    });

    test('getActors - DioException', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getActors(id: 5);

      expect(result, isA<Result<List<Actor>>>());
      expect(result.errorMessage, isA<String>());
    });
  });
}
