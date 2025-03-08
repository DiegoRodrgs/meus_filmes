import '../models/movie.dart';

class MovieService {
  static final MovieService _instance = MovieService._internal();
  factory MovieService() => _instance;
  MovieService._internal();

  final List<Movie> _movies = [];

  List<Movie> getMovies() {
    return _movies;
  }

  void addMovie(Movie movie) {
    movie.id = DateTime.now().millisecondsSinceEpoch;
    _movies.add(movie);
  }

  void updateMovie(Movie movie) {
    final index = _movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
    }
  }

  void deleteMovie(int id) {
    _movies.removeWhere((m) => m.id == id);
  }
}
