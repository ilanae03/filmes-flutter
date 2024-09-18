import 'package:flutter/material.dart';
import 'package:movie_app/common/utils.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  void _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiServices.searchMovies(query);
      setState(() {
        _searchResults = result.movies;
      });
    } catch (e) {
      print('Erro ao pesquisar filmes: $e'); // Verifique o console para mensagens de erro
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.cancel),
                  hintText: 'Search for movies...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _searchMovies(value);
                  } else {
                    setState(() {
                      _searchResults = [];
                    });
                  }
                },
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty)
              const Center(child: Text('No results found.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = _searchResults[index];
                    return ListTile(
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          '$imageUrl${movie.posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Erro ao carregar imagem: $error'); // Verifique o console para erros de imagem
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      ),
                      title: Text(movie.title),
                      subtitle: Text('Rating: ${movie.voteAverage}'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/movie_details',
                          arguments: movie,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
