# English Dictionary App

A modern Flutter application that serves as an English dictionary, allowing users to search for word definitions, examples, and manage their favorite words.

## Features

- **Word Search**: Search for any English word to get its definitions
- **Phonetic Pronunciation**: View the phonetic spelling of words
- **Multiple Definitions**: See multiple definitions with their parts of speech
- **Usage Examples**: View example sentences when available
- **Favorites System**: Save words to your favorites list for quick access
- **Material Design 3**: Modern and clean user interface
- **Text-to-Speech**: Listen to word pronunciations

## Technical Architecture

The project follows Clean Architecture principles with the following structure:

### Core Layers

1. **Presentation Layer**
   - Uses BLoC pattern for state management
   - Material Design 3 UI components
   - Responsive and user-friendly interface

2. **Domain Layer**
   - Contains business logic and entities
   - Defines repository interfaces
   - Implements use cases

3. **Data Layer**
   - Implements repository interfaces
   - Handles API communication
   - Manages local storage for favorites

### Key Components

- **DictionaryBloc**: Manages the application state and business logic
- **DictionaryRepository**: Handles data operations and API communication
- **DictionaryApiService**: Communicates with the dictionary API
- **WordCard**: Reusable UI component for displaying word information

## Dependencies

- `flutter_bloc`: ^8.1.3 - State management
- `equatable`: ^2.0.5 - Value equality
- `dartz`: ^0.10.1 - Functional programming features
- `http`: ^1.2.0 - HTTP client for API requests
- `google_fonts`: ^6.1.0 - Custom fonts
- `provider`: ^6.1.1 - Dependency injection
- `flutter_tts`: ^3.8.5 - Text-to-speech functionality

## Project Structure

```
lib/
├── core/
│   └── error/
│       └── failures.dart
├── features/
│   └── dictionary/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── dictionary_api_service.dart
│       │   ├── models/
│       │   │   └── word_response.dart
│       │   └── repositories/
│       │       └── dictionary_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── word.dart
│       │   └── repositories/
│       │       └── dictionary_repository.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── dictionary_bloc.dart
│           │   ├── dictionary_event.dart
│           │   └── dictionary_state.dart
│           ├── pages/
│           │   ├── dictionary_page.dart
│           │   └── favorites_page.dart
│           └── widgets/
│               └── word_card.dart
└── main.dart
```

## Getting Started

1. Ensure you have Flutter installed and set up on your machine
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Requirements

- Flutter SDK: >=3.2.6 <4.0.0
- Dart SDK: >=3.2.6 <4.0.0

## State Management

The application uses the BLoC (Business Logic Component) pattern for state management:

- **Events**: User actions like searching words or toggling favorites
- **States**: Different UI states (loading, loaded, error)
- **BLoC**: Processes events and emits new states

## Error Handling

The application implements comprehensive error handling:

- Network errors during API calls
- Invalid search queries
- Empty search results
- Server failures

## Future Improvements

- Offline mode support
- Word history
- Advanced search filters
- Synonyms and antonyms
- Multiple language support
- Dark mode theme
