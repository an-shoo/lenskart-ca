import '../constants/api_constants.dart';

class Movie {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final bool video;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.popularity,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      video: json['video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'popularity': popularity,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'video': video,
    };
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
  
  String get releaseYear {
    if (releaseDate == null || releaseDate!.isEmpty) {
      return '';
    }
    try {
      return releaseDate!.substring(0, 4);
    } catch (e) {
      return '';
    }
  }
  
  int get ratingPercentage => (voteAverage * 10).round();
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

