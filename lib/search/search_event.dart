
import 'package:search_example/models/search_result.dart';

abstract class SearchEvent {}

class SearchChanged extends SearchEvent{
  final String searchQuery;

  SearchChanged({
    required this.searchQuery,
  });
}

class SearchComplete extends SearchEvent {
  final List<SearchResult> searchResults;

  SearchComplete({
    required this.searchResults,
  });
}

class SearchLoadError extends SearchEvent {}

class SearchStopped extends SearchEvent {}