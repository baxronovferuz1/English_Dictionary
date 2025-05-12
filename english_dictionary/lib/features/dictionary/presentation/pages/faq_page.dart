import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text('How to use the dictionary?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Simply type a word in the search bar on the home page. '
                  'You\'ll get the definition, examples, and pronunciation. '
                  'You can also save words to your favorites.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How to save favorite words?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'When viewing a word, tap the heart icon to save it to your favorites. '
                  'You can view all your favorite words in the Liked tab.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Where to find my search history?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Your recent searches appear in the History tab. '
                  'You can quickly access previously looked up words there.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
