import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/data/search_repository.dart';
import 'package:search_example/data/search_service.dart';
import 'package:search_example/search/search_bloc.dart';
import 'package:search_example/search/search_screen.dart';

class SearchApp extends StatelessWidget {
  const SearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => SearchRepository(searchService: SearchService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => BlocProvider(
                create: (_) =>
                    SearchBloc(repo: context.read<SearchRepository>()),
                child: const SearchScreen(),
              ),
        },
      ),
    );
  }
}
