import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/common/utils.dart';
import 'package:movie_app/services/favorites_manager.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  int _userRating = 0; // A nota do usuário será um número inteiro de 0 a 5
  bool _liked = false;
  bool _disliked = false;

  bool get _isFavorite {
    return FavoritesManager.instance.isFavorite(widget.movie);
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        FavoritesManager.instance.removeFavorite(widget.movie);
      } else {
        FavoritesManager.instance.addFavorite(widget.movie);
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      if (_liked) _disliked = false;
    });
  }

  void _toggleDislike() {
    setState(() {
      _disliked = !_disliked;
      if (_disliked) _liked = false;
    });
  }

  void _rateMovie(int rating) {
    setState(() {
      _userRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  '$imageUrl${widget.movie.posterPath}',
                  height: 400,
                  width: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Release Date: ${widget.movie.releaseDate?.toLocal().toString().split(' ')[0] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Rating: ${widget.movie.voteAverage}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Seção de avaliação com estrelas
            const Text(
              'Rate this movie:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    _rateMovie(index + 1); // Avaliação vai de 1 a 5
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // Seção de like/dislike
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: _liked ? Colors.green : Colors.grey,
                  ),
                  onPressed: _toggleLike,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    color: _disliked ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleDislike,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
