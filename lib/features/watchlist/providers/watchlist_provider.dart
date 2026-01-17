import 'package:flutter/foundation.dart';
import '../../../core/models/movie.dart';
import '../../../core/services/storage_service.dart';

class WatchlistProvider extends ChangeNotifier {
  List<Movie> _watchlist = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<Movie> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  bool get isEmpty => _watchlist.isEmpty;
  bool get isInitialized => _isInitialized;

  Future<void> loadWatchlist() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _watchlist = await StorageService.getWatchlist();
      _isInitialized = true;
    } catch (e) {
      _watchlist = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isInWatchlist(int movieId) {
    return _watchlist.any((m) => m.id == movieId);
  }

  Future<void> toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie.id)) {
      await removeFromWatchlist(movie.id);
    } else {
      await addToWatchlist(movie);
    }
  }

  Future<void> addToWatchlist(Movie movie) async {
    if (!isInWatchlist(movie.id)) {
      _watchlist.add(movie);
      await StorageService.saveWatchlist(_watchlist);
      notifyListeners();
    }
  }

  Future<void> removeFromWatchlist(int movieId) async {
    _watchlist.removeWhere((m) => m.id == movieId);
    await StorageService.saveWatchlist(_watchlist);
    notifyListeners();
  }

  Future<void> clearWatchlist() async {
    _watchlist = [];
    await StorageService.saveWatchlist(_watchlist);
    notifyListeners();
  }
}

