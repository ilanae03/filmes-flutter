import 'package:movie_app/models/movie_model.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();

  FavoritesManager._internal();

  static FavoritesManager get instance => _instance;

  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Movie movie) {
    return _favorites.any((fav) => fav.id == movie.id); 
  }

  void addFavorite(Movie movie) {
    if (!isFavorite(movie)) {
      _favorites.add(movie);
    }
  }

  void removeFavorite(Movie movie) {
    _favorites.removeWhere((fav) => fav.id == movie.id); 
  }
}
