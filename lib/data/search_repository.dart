

import 'package:search_example/data/search_service.dart';
import 'package:search_example/models/search_response.dart';

class SearchRepository {
  final SearchService searchService;

  const SearchRepository({
    required this.searchService,
  });

  Future<SearchResponse> fetchSearchResults({required String searchQuery}) async {
    return await searchService.fetchSearchItems(searchQuery: searchQuery);
  }
}