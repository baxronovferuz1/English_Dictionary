class WordResponse {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  WordResponse({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory WordResponse.fromJson(Map<String, dynamic> json) {
    return WordResponse(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      phonetics: (json['phonetics'] as List<dynamic>)
          .map((e) => Phonetic.fromJson(e as Map<String, dynamic>))
          .toList(),
      meanings: (json['meanings'] as List<dynamic>)
          .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({
    this.text,
    this.audio,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'] as String?,
      audio: json['audio'] as String?,
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] as String,
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Definition {
  final String definition;
  final String? example;

  Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] as String,
      example: json['example'] as String?,
    );
  }
}
