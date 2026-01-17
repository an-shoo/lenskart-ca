import 'package:flutter/foundation.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/services/api_service.dart';

enum LoadingState { initial, loading, loaded, error, empty }

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Movies lists
  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
  
  // Movie detail
  MovieDetail? _selectedMovieDetail;

  // States
  LoadingState _moviesState = LoadingState.initial;
  LoadingState _searchState = LoadingState.initial;
  LoadingState _detailState = LoadingState.initial;

  // Error messages
  String _errorMessage = '';
  String _searchErrorMessage = '';
  String _detailErrorMessage = '';

  // Search
  String _searchQuery = '';
  bool _isSearching = false;

  // Pagination
  int _currentPage = 1;
  bool _hasMorePages = true;

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get displayedMovies => _isSearching ? _searchResults : _popularMovies;
  MovieDetail? get selectedMovieDetail => _selectedMovieDetail;
  
  LoadingState get moviesState => _moviesState;
  LoadingState get searchState => _searchState;
  LoadingState get detailState => _detailState;
  
  String get errorMessage => _errorMessage;
  String get searchErrorMessage => _searchErrorMessage;
  String get detailErrorMessage => _detailErrorMessage;
  
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  bool get hasMorePages => _hasMorePages;

  // Initialize and load popular movies
  Future<void> loadPopularMovies({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
      _popularMovies = [];
    }

    if (_moviesState == LoadingState.loading) return;

    _moviesState = _popularMovies.isEmpty 
        ? LoadingState.loading 
        : LoadingState.loaded;
    notifyListeners();

    try {
      final movies = await _apiService.getPopularMovies(page: _currentPage);
      
      if (refresh) {
        _popularMovies = movies;
      } else {
        _popularMovies.addAll(movies);
      }
      
      _hasMorePages = movies.isNotEmpty;
      _currentPage++;
      _moviesState = _popularMovies.isEmpty 
          ? LoadingState.empty 
          : LoadingState.loaded;
      _errorMessage = '';
    } catch (e) {
      _moviesState = _popularMovies.isEmpty 
          ? LoadingState.error 
          : LoadingState.loaded;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Load more movies for pagination
  Future<void> loadMoreMovies() async {
    if (!_hasMorePages || _moviesState == LoadingState.loading) return;
    await loadPopularMovies();
  }

  // Search movies
  Future<void> searchMovies(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      _searchState = LoadingState.initial;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchState = LoadingState.loading;
    notifyListeners();

    try {
      final results = await _apiService.searchMovies(query);
      _searchResults = results;
      _searchState = results.isEmpty 
          ? LoadingState.empty 
          : LoadingState.loaded;
      _searchErrorMessage = '';
    } catch (e) {
      _searchState = LoadingState.error;
      _searchErrorMessage = e.toString();
    }

    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    _searchState = LoadingState.initial;
    notifyListeners();
  }

  // Load movie details
  Future<void> loadMovieDetails(int movieId) async {
    _detailState = LoadingState.loading;
    _selectedMovieDetail = null;
    notifyListeners();

    try {
      final detail = await _apiService.getMovieDetails(movieId);
      _selectedMovieDetail = detail;
      _detailState = LoadingState.loaded;
      _detailErrorMessage = '';
    } catch (e) {
      _detailState = LoadingState.error;
      _detailErrorMessage = e.toString();
    }

    notifyListeners();
  }

  // Clear movie details
  void clearMovieDetails() {
    _selectedMovieDetail = null;
    _detailState = LoadingState.initial;
    notifyListeners();
  }
}

