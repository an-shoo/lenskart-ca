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

  bool isFavourite(int movieId) {
    return _favourites.any((m) => m.id == movieId);
  }

  Future<void> toggleFavourite(Movie movie) async {
    if (isFavourite(movie.id)) {
      await removeFromFavourites(movie.id);
    } else {
      await addToFavourites(movie);
    }
  }

  Future<void> addToFavourites(Movie movie) async {
    if (!isFavourite(movie.id)) {
      _favourites.add(movie);
      await StorageService.saveFavourites(_favourites);
      notifyListeners();
    }
  }

  Future<void> removeFromFavourites(int movieId) async {
    _favourites.removeWhere((m) => m.id == movieId);
    await StorageService.saveFavourites(_favourites);
    notifyListeners();
  }

  Future<void> clearFavourites() async {
    _favourites = [];
    await StorageService.saveFavourites(_favourites);
    notifyListeners();
  }
}
