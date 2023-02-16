import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/search/search_bloc.dart';
import 'package:search_example/search/search_event.dart';
import 'package:search_example/search/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search Movies!'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (searchQuery) => context.read<SearchBloc>().add(SearchChanged(searchQuery: searchQuery)),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search movies here',
              ),
            ),
            Builder(builder: (_) {
              if (state is SearchLoadingState) {
                return const CircularProgressIndicator();
              }

              if (state is SearchInitial) {
                return const Text('Enter text to begin searching!');
              }

              if (state is SearchNoItems) {
                return const Text('Sorry, that search returned zero results :(');
              }

              if (state is SearchError) {
                return const Text('An error has occurred, please try again');
              }

              if (state is SearchLoaded) {
                return Expanded(
                  child: ListView.builder(itemCount: state.searchResults.length, itemBuilder: (context, index) {
                    final searchResult = state.searchResults[index];

                    return Card(
                      child: ListTile(
                        title: Text(searchResult.title),
                        subtitle: Text(searchResult.message),
                      ),
                    );
                  }),
                );
              }

              return const SizedBox.shrink();
            },)
          ],
        ),
      );
    });
  }
}
