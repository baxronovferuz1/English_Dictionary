import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/search_history_provider.dart';
import '../../../../core/providers/liked_words_provider.dart';
import '../bloc/dictionary_bloc.dart';
import '../bloc/dictionary_event.dart';
import '../bloc/dictionary_state.dart';
import '../widgets/word_card.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(BuildContext context, String query) {
    if (query.trim().isNotEmpty) {
      // Only search when Enter is pressed or Search button is tapped
      // Remove automatic search on text change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a word...',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.trim().isNotEmpty) {
                      context.read<DictionaryBloc>().add(
                        SearchWord(query: _searchController.text.trim()),
                      );
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context.read<DictionaryBloc>().add(
                    SearchWord(query: query.trim()),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<DictionaryBloc, DictionaryState>(
              listener: (context, state) {
                if (state is DictionaryError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                if (state is WordsLoaded && state.words.isNotEmpty) {
                  context.read<SearchHistoryProvider>().addSearch(
                        state.words.first.term,
                        state.words.first,
                      );
                }
              },
              builder: (context, state) {
                Widget buildEmptyState() {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          size: 80,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Type to search for any word',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Get definitions, examples, and more',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DictionaryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WordsLoaded) {
                  if (state.words.isEmpty && _searchController.text.isNotEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.words.isEmpty) {
                    return buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.words.length,
                    itemBuilder: (context, index) {
                      final word = state.words[index];
                      final likedWordsProvider = context.watch<LikedWordsProvider>();
                      final isLiked = likedWordsProvider.isWordLiked(word.term);
                      
                      return WordCard(
                        word: word.copyWith(isFavorite: isLiked),
                        onFavoritePressed: () {
                          // Toggle in both DictionaryBloc and LikedWordsProvider
                          context.read<DictionaryBloc>().add(ToggleFavorite(word));
                          likedWordsProvider.toggleLikedWord(word);
                        },
                      );
                    },
                  );
                }

                // Show empty state for initial state and any other states
                return buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }
}
