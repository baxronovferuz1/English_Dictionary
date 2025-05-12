import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/custom_words_provider.dart';
import 'core/providers/liked_words_provider.dart';
import 'core/providers/search_history_provider.dart';
import 'core/providers/theme_provider.dart';
import 'features/dictionary/data/datasources/dictionary_api_service.dart';
import 'features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'features/dictionary/domain/repositories/dictionary_repository.dart';
import 'features/dictionary/presentation/bloc/dictionary_bloc.dart';
import 'features/dictionary/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SearchHistoryProvider()),
        ChangeNotifierProvider(create: (_) => LikedWordsProvider()),
        ChangeNotifierProvider(create: (_) => CustomWordsProvider()),
        Provider<DictionaryApiService>(
          create: (_) => DictionaryApiService(),
        ),
        ProxyProvider<DictionaryApiService, DictionaryRepository>(
          update: (_, apiService, __) => DictionaryRepositoryImpl(apiService: apiService),
        ),
        ProxyProvider<DictionaryRepository, DictionaryBloc>(
          update: (_, repository, __) => DictionaryBloc(repository: repository),
          dispose: (_, bloc) => bloc.close(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dictionary',
            theme: themeProvider.themeData,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
