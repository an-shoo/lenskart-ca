class ApiConstants {
  // TMDB API Configuration
  // You need to replace this with your own API key from https://www.themoviedb.org/
  static const String apiKey = 'a36bab8a5922acff32013f688b2624ad';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Image sizes
  static const String posterSize = '/w500';
  static const String backdropSize = '/w780';
  static const String originalSize = '/original';

  // Endpoints
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String upcomingMovies = '/movie/upcoming';
  static const String searchMovies = '/search/movie';
  static const String movieDetails = '/movie';
  static const String genreList = '/genre/movie/list';

  // Helper methods
  static String getPosterUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$imageBaseUrl$posterSize$path';
  }

  static String getBackdropUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$imageBaseUrl$backdropSize$path';
  }

  static String getOriginalImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$imageBaseUrl$originalSize$path';
  }
}
