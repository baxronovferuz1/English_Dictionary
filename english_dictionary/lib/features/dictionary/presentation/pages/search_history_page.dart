import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/search_history_provider.dart';
import 'word_details_page.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: Consumer<SearchHistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.searchHistory.isEmpty) {
            return const Center(
              child: Text('No search history'),
            );
          }
          return ListView.builder(
            itemCount: historyProvider.searchHistory.length,
            itemBuilder: (context, index) {
              final entry = historyProvider.searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(entry.value.term),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Provider.of<SearchHistoryProvider>(context, listen: false)
                        .removeSearch(entry.value.term);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordDetailsPage(word: entry.value),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
