import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/word.dart';

class WordCard extends StatefulWidget {
  final Word word;
  final VoidCallback onFavoritePressed;

  const WordCard({
    super.key,
    required this.word,
    required this.onFavoritePressed,
  });



  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.word.term,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                      )),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          _speak(widget.word.term);
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.word.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.word.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    if (widget.word.isFavorite) {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Remove from Favorites'),
                            content: Text('Are you sure you want to remove "${widget.word.term}" from favorites?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Remove'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      ) ?? false;
                      if (shouldRemove) {
                        widget.onFavoritePressed();
                      }
                    } else {
                      widget.onFavoritePressed();
                    }
                  },
                ),
              ],
            ),
            if (widget.word.pronunciation.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.word.pronunciation,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (widget.word.definitions.isNotEmpty) ...[
              Text(
                'Meaning:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              ...widget.word.definitions.map(
                (definition) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          definition,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.word.example != null && widget.word.example!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Example:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.word.example!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
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
