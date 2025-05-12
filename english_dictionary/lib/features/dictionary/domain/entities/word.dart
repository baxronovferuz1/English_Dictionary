import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String term;
  final String pronunciation;
  final List<String> definitions;
  final String? example;
  final bool isFavorite;

  const Word({
    required this.term,
    required this.pronunciation,
    required this.definitions,
    this.example,
    this.isFavorite = false,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      term: json['term'] as String,
      pronunciation: json['pronunciation'] as String,
      definitions: List<String>.from(json['definitions'] as List),
      example: json['example'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'pronunciation': pronunciation,
      'definitions': definitions,
      'example': example,
      'isFavorite': isFavorite,
    };
  }

  Word copyWith({
    String? term,
    String? pronunciation,
    List<String>? definitions,
    String? example,
    bool? isFavorite,
  }) {
    return Word(
      term: term ?? this.term,
      pronunciation: pronunciation ?? this.pronunciation,
      definitions: definitions ?? this.definitions,
      example: example ?? this.example,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [term, pronunciation, definitions, example, isFavorite];
}
