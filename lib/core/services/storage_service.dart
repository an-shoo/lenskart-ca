import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class StorageService {
  static const String _favouritesKey = 'favourites';
  static const String _watchlistKey = 'watchlist';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<List<Movie>> getFavourites() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_favouritesKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<void> saveFavourites(List<Movie> movies) async {
    final prefs = await _prefs;
    final jsonList = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_favouritesKey, json.encode(jsonList));
  }

  static Future<void> addToFavourites(Movie movie) async {
    final favourites = await getFavourites();
    if (!favourites.contains(movie)) {
      favourites.add(movie);
      await saveFavourites(favourites);
    }
  }

  static Future<void> removeFromFavourites(int movieId) async {
    final favourites = await getFavourites();
    favourites.removeWhere((m) => m.id == movieId);
    await saveFavourites(favourites);
  }

  static Future<bool> isFavourite(int movieId) async {
    final favourites = await getFavourites();
    return favourites.any((m) => m.id == movieId);
  }

  static Future<List<Movie>> getWatchlist() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_watchlistKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<void> saveWatchlist(List<Movie> movies) async {
    final prefs = await _prefs;
    final jsonList = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_watchlistKey, json.encode(jsonList));
  }

  static Future<void> addToWatchlist(Movie movie) async {
    final watchlist = await getWatchlist();
    if (!watchlist.contains(movie)) {
      watchlist.add(movie);
      await saveWatchlist(watchlist);
    }
  }

  static Future<void> removeFromWatchlist(int movieId) async {
    final watchlist = await getWatchlist();
    watchlist.removeWhere((m) => m.id == movieId);
    await saveWatchlist(watchlist);
  }

  static Future<bool> isInWatchlist(int movieId) async {
    final watchlist = await getWatchlist();
    return watchlist.any((m) => m.id == movieId);
  }
}

