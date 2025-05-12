import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/word.dart';

abstract class DictionaryRepository {
  Future<Either<Failure, List<Word>>> getWords();
  Future<Either<Failure, List<Word>>> searchWords(String query);
  Future<Either<Failure, List<Word>>> searchFavoriteWords(String query);
  Future<Either<Failure, Word>> toggleFavorite(Word word);
}
