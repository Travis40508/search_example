
import 'package:search_example/models/search_result.dart';

class SearchResponse {
  final bool success;
  final List<SearchResult> searchResults;

  const SearchResponse({
    required this.success,
    required this.searchResults,
  });
}