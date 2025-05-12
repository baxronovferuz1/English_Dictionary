import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dictionary_bloc.dart';
import '../bloc/dictionary_event.dart';
import '../bloc/dictionary_state.dart';
import '../widgets/word_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<DictionaryBloc>().add(LoadFavorites());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshFavorites() {
    if (!mounted) return;
    context.read<DictionaryBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<DictionaryBloc>().add(LoadDefaultWords());
            Navigator.of(context).pop();
          },
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search favorite words...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  context.read<DictionaryBloc>().add(
                    SearchWord(query: query, searchInFavorites: true),
                  );
                },
              )
            : const Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _refreshFavorites();
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<DictionaryBloc, DictionaryState>(
        listener: (context, state) {
          if (state is DictionaryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DictionaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is WordsLoaded) {
            if (state.words.isEmpty) {
              return Center(
                child: Text(
                  _isSearching
                      ? 'No matching favorites found'
                      : 'No favorite words yet',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.words.length,
              itemBuilder: (context, index) {
                final word = state.words[index];
                return WordCard(
                  word: word,
                  onFavoritePressed: () {
                    context.read<DictionaryBloc>().add(ToggleFavorite(word));
                    // Refresh favorites after toggling
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      _refreshFavorites,
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
