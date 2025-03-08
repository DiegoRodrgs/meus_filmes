import 'dart:io';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();

  @override
  Widget build(BuildContext context) {
    List<Movie> movies = movieService.getMovies();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Filmes'),
      ),
      body: movies.isEmpty
          ? const Center(child: Text('Nenhum filme cadastrado.'))
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Movie movie = movies[index];
          return GestureDetector(
            onTap: () async {
              final updatedMovie = await Navigator.push<Movie>(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieFormScreen(movie: movie),
                ),
              );
              if (updatedMovie != null) {
                movieService.updateMovie(updatedMovie);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filme atualizado com sucesso!')),
                );
              }
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remover Filme'),
                  content: const Text('Deseja remover este filme?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        movieService.deleteMovie(movie.id!);
                        setState(() {});
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filme removido com sucesso!')),
                        );
                      },
                      child: const Text('Remover'),
                    ),
                  ],
                ),
              );
            },
            child: ListTile(
              leading: movie.posterPath.isNotEmpty
                  ? Image.file(
                File(movie.posterPath),
                width: 50,
                height: 80,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 50,
                height: 80,
                color: Colors.grey,
                child: const Icon(Icons.movie),
              ),
              title: Text(movie.title),
              subtitle: Text('${movie.year} - ${movie.director}'),
              trailing: Text(movie.rating.toStringAsFixed(1)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMovie = await Navigator.push<Movie>(
            context,
            MaterialPageRoute(
              builder: (_) => const MovieFormScreen(),
            ),
          );
          if (newMovie != null) {
            movieService.addMovie(newMovie);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filme cadastrado com sucesso!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
