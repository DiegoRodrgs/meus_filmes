class Movie {
  int? id;
  String title;
  int year;
  String director;
  String summary;
  String posterPath;
  double rating;

  Movie({
    this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.summary,
    required this.posterPath,
    required this.rating,
  });
}
