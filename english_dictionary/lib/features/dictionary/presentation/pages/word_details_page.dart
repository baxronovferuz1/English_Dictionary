import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/word.dart';
import '../bloc/dictionary_bloc.dart';
import '../bloc/dictionary_event.dart';

class WordDetailsPage extends StatelessWidget {
  final Word word;

  const WordDetailsPage({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.term),
        actions: [
          IconButton(
            icon: Icon(
              word.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              context.read<DictionaryBloc>().add(ToggleFavorite(word));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (word.pronunciation.isNotEmpty) ...[              
              Text(
                'Pronunciation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                word.pronunciation,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
            ],
            Text(
              'Definitions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...word.definitions.map((definition) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      definition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            )),
            if (word.example != null && word.example!.isNotEmpty) ...[              
              const SizedBox(height: 24),
              Text(
                'Example',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                word.example!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
