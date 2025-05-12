import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dictionary/domain/entities/word.dart';

class LikedWordsProvider with ChangeNotifier {
  static const String _likedKey = 'liked_words';
  late SharedPreferences _prefs;
  Map<String, Word> _likedWords = {};

  List<MapEntry<String, Word>> get likedWords => _likedWords.entries.toList();

  LikedWordsProvider() {
    _loadLikedWords();
  }

  Future<void> _loadLikedWords() async {
    _prefs = await SharedPreferences.getInstance();
    final String? likedJson = _prefs.getString(_likedKey);
    if (likedJson != null) {
      final Map<String, dynamic> likedMap = jsonDecode(likedJson);
      _likedWords = likedMap.map(
        (key, value) => MapEntry(
          key,
          Word.fromJson(value as Map<String, dynamic>),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> toggleLikedWord(Word word) async {
    if (_likedWords.containsKey(word.term)) {
      _likedWords.remove(word.term);
    } else {
      _likedWords[word.term] = word;
    }
    await _saveLikedWords();
    notifyListeners();
  }

  bool isWordLiked(String term) {
    return _likedWords.containsKey(term);
  }

  Future<void> _saveLikedWords() async {
    final likedJson = jsonEncode(
      _likedWords.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs.setString(_likedKey, likedJson);
  }
}
