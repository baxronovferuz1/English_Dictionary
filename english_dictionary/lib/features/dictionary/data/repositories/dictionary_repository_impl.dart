import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/word.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_api_service.dart';
import '../models/word_response.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryApiService _apiService;
  final List<Word> _favoriteWords = [];

  DictionaryRepositoryImpl({required DictionaryApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failure, List<Word>>> getWords() async {
    try {
      return Right(_favoriteWords);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Word>>> searchWords(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase().trim();
      
      if (lowercaseQuery.isEmpty) {
        return const Right([]);
      }

      print('Repository: searching for "$lowercaseQuery"');
      // Get word definitions from API
      final responses = await _apiService.getWordDefinition(lowercaseQuery);
      print('Repository: got ${responses.length} responses');
      if (responses.isEmpty) {
        print('Repository: no responses found');
        return const Right([]);
      }

      // Find the exact word match from responses
      final exactMatch = responses.firstWhere(
        (response) => response.word.toLowerCase() == lowercaseQuery,
        orElse: () => responses.first
      );
      
      final meanings = exactMatch.meanings;
        
      // Get the best pronunciation available
      String pronunciation = exactMatch.phonetic ?? '';
      if (pronunciation.isEmpty && exactMatch.phonetics.isNotEmpty) {
        pronunciation = exactMatch.phonetics.firstWhere(
          (p) => p.text != null && p.text!.isNotEmpty,
          orElse: () => Phonetic(text: '')
        ).text ?? '';
      }

      // Get examples from definitions
      String? example;
      for (final meaning in meanings) {
        for (final def in meaning.definitions) {
          if (def.example != null && def.example!.isNotEmpty) {
            example = def.example;
            break;
          }
        }
        if (example != null) break;
      }
      
      final word = Word(
        term: exactMatch.word,
        pronunciation: pronunciation,
        definitions: meanings.expand((m) => 
          m.definitions.map((d) => '(${m.partOfSpeech}) ${d.definition}')
        ).toList(),
        example: example,
        isFavorite: _favoriteWords.any((w) => w.term.toLowerCase() == exactMatch.word.toLowerCase()),
      );

      return Right([word]);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Word>>> searchFavoriteWords(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase().trim();
      final matches = _favoriteWords
          .where((word) => word.term.toLowerCase().contains(lowercaseQuery))
          .toList();
      return Right(matches);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Word>> toggleFavorite(Word word) async {
    try {
      final index = _favoriteWords.indexWhere(
        (w) => w.term.toLowerCase() == word.term.toLowerCase()
      );

      if (index != -1) {
        _favoriteWords.removeAt(index);
        return Right(word.copyWith(isFavorite: false));
      } else {
        _favoriteWords.add(word.copyWith(isFavorite: true));
        return Right(word.copyWith(isFavorite: true));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
