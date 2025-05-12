import 'package:equatable/equatable.dart';
import '../../domain/entities/word.dart';

abstract class DictionaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);
  
  @override
  List<Object> get props => [message];
}

class WordsLoaded extends DictionaryState {
  final List<Word> words;
  WordsLoaded(this.words);
  
  @override
  List<Object> get props => [words];
}
