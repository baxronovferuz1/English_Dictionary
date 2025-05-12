import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/liked_words_provider.dart';
import '../widgets/word_card.dart';

class LikedWordsPage extends StatelessWidget {
  const LikedWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: Consumer<LikedWordsProvider>(
        builder: (context, likedProvider, child) {
          if (likedProvider.likedWords.isEmpty) {
            return const Center(
              child: Text('No liked words'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: likedProvider.likedWords.length,
            itemBuilder: (context, index) {
              final word = likedProvider.likedWords[index].value;
              return WordCard(
                word: word.copyWith(isFavorite: true),
                onFavoritePressed: () {
                  likedProvider.toggleLikedWord(word);
                },
              );
            },
          );
        },
      ),
    );
  }
}
