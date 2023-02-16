import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search_example/data/search_repository.dart';
import 'package:search_example/models/search_response.dart';
import 'package:search_example/models/search_result.dart';
import 'package:search_example/search/search_bloc.dart';
import 'package:search_example/search/search_event.dart';
import 'package:search_example/search/search_state.dart';

import 'mocks.dart';

void main() {
  late SearchRepository repository;

  setUp(() {
    repository = SearchRepositoryMock();
  });

  test('Initial State', () {
    final searchBloc = SearchBloc(repo: repository);

    expect(searchBloc.state, SearchInitial());
  });

  blocTest<SearchBloc, SearchState>(
    'Loading State',
    setUp: () {
      // This creates a state where the repo never returns data, so we should see a loading state.
      when(() => repository.fetchSearchResults(
              searchQuery: any(named: 'searchQuery')))
          .thenAnswer((_) => Future.any([]));
    },
    act: (bloc) async {
      bloc.add(SearchChanged(searchQuery: 'Rocky'));

      await pumpEventQueue();
    },
    build: () => SearchBloc(repo: repository, searchWaitTime: 0),
    expect: () => [
      isA<SearchLoadingState>(),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'Should fire initial state when query is empty',
    setUp: () {
      when(() => repository.fetchSearchResults(
          searchQuery: any(named: 'searchQuery'))).thenAnswer(
        (_) => Future.value(
          const SearchResponse(
            success: true,
            searchResults: [
              SearchResult(
                title: 'Rocky',
                message: 'Rocky Message',
              )
            ],
          ),
        ),
      );
    },
    act: (bloc) async {
      bloc.add(SearchChanged(searchQuery: 'Rocky'));
      await pumpEventQueue();

      bloc.add(SearchChanged(searchQuery: ''));
    },
    build: () => SearchBloc(repo: repository, searchWaitTime: 0),
    expect: () => [
      isA<SearchLoadingState>(),
      isA<SearchLoaded>().having((state) => state.searchResults.first.title,
          'It returns titles correctly', 'Rocky'),
      isA<SearchInitial>(),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'Should fire error state whenever call fails',
    setUp: () {
      when(() => repository.fetchSearchResults(
          searchQuery: any(named: 'searchQuery'))).thenAnswer(
        (_) => Future.value(
          const SearchResponse(
            success: false,
            searchResults: [],
          ),
        ),
      );
    },
    act: (bloc) async {
      bloc.add(SearchChanged(searchQuery: 'Rocky'));
      await pumpEventQueue();
    },
    build: () => SearchBloc(repo: repository, searchWaitTime: 0),
    expect: () => [
      isA<SearchLoadingState>(),
      isA<SearchError>(),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'Should fire loaded state when proper data is returned',
    setUp: () {
      when(() => repository.fetchSearchResults(
          searchQuery: any(named: 'searchQuery'))).thenAnswer(
        (_) => Future.value(
          const SearchResponse(
            success: true,
            searchResults: [
              SearchResult(
                title: 'Rocky',
                message: 'Rocky Message',
              )
            ],
          ),
        ),
      );
    },
    act: (bloc) async {
      bloc.add(SearchChanged(searchQuery: 'Rocky'));
      await pumpEventQueue();
    },
    build: () => SearchBloc(repo: repository, searchWaitTime: 0),
    expect: () => [
      isA<SearchLoadingState>(),
      isA<SearchLoaded>().having((state) => state.searchResults.first.title,
          'It returns titles correctly', 'Rocky'),
    ],
  );
}
