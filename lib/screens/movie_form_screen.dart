import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';

class MovieFormScreen extends StatefulWidget {
  final Movie? movie;
  const MovieFormScreen({super.key, this.movie});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _directorController;
  late TextEditingController _summaryController;
  String posterPath = '';
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _yearController = TextEditingController(text: widget.movie?.year.toString() ?? '');
    _directorController = TextEditingController(text: widget.movie?.director ?? '');
    _summaryController = TextEditingController(text: widget.movie?.summary ?? '');
    posterPath = widget.movie?.posterPath ?? '';
    rating = widget.movie?.rating ?? 3.0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _directorController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        posterPath = pickedFile.path;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (posterPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um cartaz para o filme.')));
        return;
      }
      Movie movie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        year: int.tryParse(_yearController.text) ?? 0,
        director: _directorController.text,
        summary: _summaryController.text,
        posterPath: posterPath,
        rating: rating,
      );
      Navigator.pop(context, movie);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filme salvo com sucesso!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, corrija os erros do formulário.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.movie != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Filme' : 'Cadastrar Filme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o título do filme.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o ano do filme.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ano inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Direção', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o diretor do filme.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Resumo', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um resumo do filme.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Selecionar Cartaz'),
                  ),
                  const SizedBox(width: 16),
                  posterPath.isNotEmpty
                      ? Image.file(File(posterPath), width: 50, height: 75, fit: BoxFit.cover)
                      : const Text('Nenhum cartaz selecionado'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Nota:'),
                  const SizedBox(width: 8),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    maxRating: 5,
                    itemSize: 30,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(rating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(isEditing ? 'Atualizar Filme' : 'Salvar Filme'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
