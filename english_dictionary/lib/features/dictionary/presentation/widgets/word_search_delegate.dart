import 'package:flutter/material.dart';

class WordSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  WordSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // We don't need this as we're using suggestions
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Search as you type
    if (query.isNotEmpty) {
      onSearch(query);
    }
    return Container(); // The results will be shown in the main list
  }
}
