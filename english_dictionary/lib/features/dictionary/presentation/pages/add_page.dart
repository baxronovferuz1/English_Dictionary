import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/custom_words_provider.dart';
import '../../domain/entities/word.dart';
import '../bloc/dictionary_bloc.dart';
import '../bloc/dictionary_event.dart';
import '../bloc/dictionary_state.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _definitionController = TextEditingController();
  final _exampleController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final word = _wordController.text.trim();
      
      // First check if the word exists in the API
      final dictionaryBloc = context.read<DictionaryBloc>();
      dictionaryBloc.add(SearchWord(query: word));
      
      // Wait for the search result
      final state = await dictionaryBloc.stream.firstWhere(
        (state) => state is WordsLoaded || state is DictionaryError,
      );
      
      if (state is WordsLoaded) {
        final words = state.words;
        if (words.isNotEmpty) {
          setState(() {
            _errorMessage = 'This word already exists in the dictionary';
          });
          return;
        }
      }
      
      // Word not found in API or error occurred, proceed with adding custom word
      final customWord = Word(
        term: word,
        pronunciation: '',
        definitions: [_definitionController.text.trim()],
        example: _exampleController.text.trim().isNotEmpty 
            ? _exampleController.text.trim()
            : null,
      );

      context.read<CustomWordsProvider>().addCustomWord(customWord);
      
      // Clear form and show success message
      _wordController.clear();
      _definitionController.clear();
      _exampleController.clear();
      setState(() {
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Custom Word',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red.shade900,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Word',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _definitionController,
                decoration: const InputDecoration(
                  labelText: 'Definition',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a definition';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _exampleController,
                decoration: const InputDecoration(
                  labelText: 'Example (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Word'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
