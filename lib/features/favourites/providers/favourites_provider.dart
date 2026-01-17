import 'package:flutter/foundation.dart';
import '../../../core/models/movie.dart';
import '../../../core/services/storage_service.dart';

class FavouritesProvider extends ChangeNotifier {
  List<Movie> _favourites = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<Movie> get favourites => _favourites;
  bool get isLoading => _isLoading;
  bool get isEmpty => _favourites.isEmpty;
  bool get isInitialized => _isInitialized;

  // Initialize and load favourites from storage
  Future<void> loadFavourites() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _favourites = await StorageService.getFavourites();
      _isInitialized = true;
    } catch (e) {
      _favourites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Check if a movie is in favourites
  bool isFavourite(int movieId) {
    return _favourites.any((m) => m.id == movieId);
  }

  // Toggle favourite status
  Future<void> toggleFavourite(Movie movie) async {
    if (isFavourite(movie.id)) {
      await removeFromFavourites(movie.id);
    } else {
      await addToFavourites(movie);
    }
  }

  // Add to favourites
  Future<void> addToFavourites(Movie movie) async {
    if (!isFavourite(movie.id)) {
      _favourites.add(movie);
      await StorageService.saveFavourites(_favourites);
      notifyListeners();
    }
  }

  // Remove from favourites
  Future<void> removeFromFavourites(int movieId) async {
    _favourites.removeWhere((m) => m.id == movieId);
    await StorageService.saveFavourites(_favourites);
    notifyListeners();
  }

  // Clear all favourites
  Future<void> clearFavourites() async {
    _favourites = [];
    await StorageService.saveFavourites(_favourites);
    notifyListeners();
  }
}

