import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dictionary/domain/entities/word.dart';

class CustomWordsProvider with ChangeNotifier {
  static const String _customWordsKey = 'custom_words';
  late SharedPreferences _prefs;
  Map<String, Word> _customWords = {};

  List<Word> get customWords => _customWords.values.toList();

  CustomWordsProvider() {
    _loadCustomWords();
  }

  Future<void> _loadCustomWords() async {
    _prefs = await SharedPreferences.getInstance();
    final String? wordsJson = _prefs.getString(_customWordsKey);
    if (wordsJson != null) {
      final Map<String, dynamic> wordsMap = jsonDecode(wordsJson);
      _customWords = wordsMap.map(
        (key, value) => MapEntry(
          key,
          Word.fromJson(value as Map<String, dynamic>),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> addCustomWord(Word word) async {
    if (word.term.isEmpty) return;
    
    _customWords[word.term.toLowerCase()] = word;
    await _saveCustomWords();
    notifyListeners();
  }

  bool hasWord(String term) {
    return _customWords.containsKey(term.toLowerCase());
  }

  Word? getWord(String term) {
    return _customWords[term.toLowerCase()];
  }

  Future<void> _saveCustomWords() async {
    final wordsJson = jsonEncode(
      _customWords.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs.setString(_customWordsKey, wordsJson);
  }
}
