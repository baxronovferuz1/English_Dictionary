import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/dictionary_repository.dart';
import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository repository;

  DictionaryBloc({required this.repository}) : super(DictionaryInitial()) {
    on<LoadDefaultWords>(_onLoadDefaultWords);
    on<SearchWord>(_onSearchWord);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadDefaultWords(LoadDefaultWords event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoading());
    final result = await repository.getWords();
    result.fold(
      (failure) => emit(DictionaryError('Failed to load favorite words')),
      (words) => emit(WordsLoaded(words)),
    );
  }

  Future<void> _onSearchWord(SearchWord event, Emitter<DictionaryState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(WordsLoaded(const []));
      return;
    }

    // Clear previous results first
    emit(DictionaryLoading());
    
    final result = event.searchInFavorites
        ? await repository.searchFavoriteWords(event.query)
        : await repository.searchWords(event.query);
    
    // Handle the case when a new search is initiated while waiting for results
    if (state is! DictionaryLoading) return;
    
    result.fold(
      (failure) => emit(DictionaryError('Failed to connect to the dictionary service. Please check your internet connection and try again.')),
      (words) => emit(WordsLoaded(words)),
    );
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<DictionaryState> emit) async {
    final currentState = state;
    final result = await repository.toggleFavorite(event.word);
    
    result.fold(
      (failure) => emit(DictionaryError('Failed to toggle favorite status')),
      (updatedWord) {
        if (currentState is WordsLoaded) {
          final updatedWords = currentState.words.map((word) {
            if (word.term.toLowerCase() == updatedWord.term.toLowerCase()) {
              return updatedWord;
            }
            return word;
          }).toList();
          emit(WordsLoaded(updatedWords));
        }
      },
    );
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoading());
    final result = await repository.getWords();
    result.fold(
      (failure) => emit(DictionaryError('Failed to load favorite words')),
      (words) => emit(WordsLoaded(words)),
    );
  }
}
