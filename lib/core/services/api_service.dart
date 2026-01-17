import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, dynamic>> _get(String endpoint,
      {Map<String, String>? params}) async {
    final queryParams = {
      'api_key': ApiConstants.apiKey,
      ...?params,
    };

    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw ApiException('Invalid API key. Please check your TMDB API key.');
      } else if (response.statusCode == 404) {
        throw ApiException('Resource not found.');
      } else {
        throw ApiException(
            'Failed to load data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
          'Network error. Please check your internet connection.');
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final response = await _get(ApiConstants.popularMovies, params: {
      'page': page.toString(),
    });

    final results = response['results'] as List<dynamic>? ?? [];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await _get(ApiConstants.topRatedMovies, params: {
      'page': page.toString(),
    });

    final results = response['results'] as List<dynamic>? ?? [];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await _get(ApiConstants.nowPlayingMovies, params: {
      'page': page.toString(),
    });

    final results = response['results'] as List<dynamic>? ?? [];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await _get(ApiConstants.upcomingMovies, params: {
      'page': page.toString(),
    });

    final results = response['results'] as List<dynamic>? ?? [];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final response = await _get(ApiConstants.searchMovies, params: {
      'query': query,
      'page': page.toString(),
    });

    final results = response['results'] as List<dynamic>? ?? [];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    final response = await _get('${ApiConstants.movieDetails}/$movieId');
    return MovieDetail.fromJson(response);
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
