import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_response.dart';

class DictionaryApiService {
  final String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<List<WordResponse>> getWordDefinition(String word) async {
    try {
      print('Searching for word: $word');
      final response = await http.get(Uri.parse('$baseUrl/$word'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final results = jsonList
            .map((json) => WordResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        print('Parsed ${results.length} results');
        return results;
      } else if (response.statusCode == 404) {
        print('Word not found');
        return [];
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load word definition');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to connect to the dictionary API');
    }
  }
}
