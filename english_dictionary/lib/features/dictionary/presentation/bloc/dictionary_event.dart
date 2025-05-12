import 'package:equatable/equatable.dart';
import '../../domain/entities/word.dart';

abstract class DictionaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDefaultWords extends DictionaryEvent {}

class SearchWord extends DictionaryEvent {
  final String query;
  final bool searchInFavorites;
  SearchWord({required this.query, this.searchInFavorites = false});

  @override
  List<Object> get props => [query, searchInFavorites];
}

class ToggleFavorite extends DictionaryEvent {
  final Word word;
  ToggleFavorite(this.word);
  
  @override
  List<Object> get props => [word];
}

class LoadFavorites extends DictionaryEvent {}
