import '../constants/api_constants.dart';
import 'genre.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<Genre> genres;
  final int? runtime;
  final String? status;
  final String? tagline;
  final int? budget;
  final int? revenue;
  final String? homepage;
  final String? imdbId;
  final double popularity;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;

  MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    this.runtime,
    this.status,
    this.tagline,
    this.budget,
    this.revenue,
    this.homepage,
    this.imdbId,
    required this.popularity,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      budget: json['budget'],
      revenue: json['revenue'],
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      popularity: (json['popularity'] ?? 0).toDouble(),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
    );
  }

  String get posterUrl => ApiConstants.getPosterUrl(posterPath);
  String get backdropUrl => ApiConstants.getBackdropUrl(backdropPath);

  String get formattedReleaseDate {
    if (releaseDate == null || releaseDate!.isEmpty) {
      return 'Unknown';
    }
    try {
      final date = DateTime.parse(releaseDate!);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return releaseDate!;
    }
  }

  String get formattedRuntime {
    if (runtime == null) return 'Unknown';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get genreString {
    return genres.map((g) => g.name).join(', ');
  }

  int get ratingPercentage => (voteAverage * 10).round();
}

