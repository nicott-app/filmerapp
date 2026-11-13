import 'package:filmer/models/movie.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/services/movie_service.dart';

abstract class MovieRepository {
  Future<Result<List<Movie>>> getPopularMovies({int page = 1});
  Future<Result<String?>> getMovieTrailerKey(int movieId);
}

class MovieRepositoryImpl implements MovieRepository {
  final MovieService _movieService;

  MovieRepositoryImpl(this._movieService);

  @override
  Future<Result<List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await _movieService.getPopularMovies(page: page);
      if (movies.isEmpty) {
        return const Failure("No movies found or invalid API Key.");
      }
      return Success(movies);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<String?>> getMovieTrailerKey(int movieId) async {
    try {
      final key = await _movieService.getMovieTrailerKey(movieId);
      return Success(key);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
