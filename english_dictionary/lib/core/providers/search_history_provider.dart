import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dictionary/domain/entities/word.dart';

class SearchHistoryProvider with ChangeNotifier {
  static const String _historyKey = 'search_history';
  late SharedPreferences _prefs;
  Map<String, Word> _searchHistory = {};

  List<MapEntry<String, Word>> get searchHistory => _searchHistory.entries.toList();

  SearchHistoryProvider() {
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final String? historyJson = _prefs.getString(_historyKey);
    if (historyJson != null) {
      final Map<String, dynamic> historyMap = jsonDecode(historyJson);
      _searchHistory = historyMap.map(
        (key, value) => MapEntry(
          key,
          Word.fromJson(value as Map<String, dynamic>),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> addSearch(String term, Word word) async {
    if (term.isEmpty) return;
    
    // Add or update the word data
    _searchHistory[term] = word;
    
    // Keep only last 20 searches
    if (_searchHistory.length > 20) {
      final entries = _searchHistory.entries.toList();
      _searchHistory = Map.fromEntries(entries.take(20));
    }
    
    await _saveSearchHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _searchHistory.clear();
    await _saveSearchHistory();
    notifyListeners();
  }

  Word? getWord(String term) {
    return _searchHistory[term];
  }

  Future<void> removeSearch(String term) async {
    _searchHistory.remove(term);
    await _saveSearchHistory();
    notifyListeners();
  }

  Future<void> _saveSearchHistory() async {
    final historyJson = jsonEncode(
      _searchHistory.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs.setString(_historyKey, historyJson);
  }
}
