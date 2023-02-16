
import 'package:search_example/models/search_response.dart';
import 'package:search_example/models/search_result.dart';

class SearchService {

  // Mocked API data set.
  List<SearchResult> get searchResults => const [
    SearchResult(title: 'Rocky', message: 'A boxer achieves his dream.'),
    SearchResult(title: 'Star Wars', message: 'Light Saber battles!'),
    SearchResult(title: 'Shrek', message: 'Our favorite Ogre'),
    SearchResult(title: 'Braveheart', message: 'Scotland fights for independence'),
    SearchResult(title: 'James Bond', message: 'Shaken, not stirred'),
    SearchResult(title: 'Lord of the Rings', message: 'A ring must be destroyed.'),
  ];

  Future<SearchResponse> fetchSearchItems({required String searchQuery}) async {
    // Make both lower cased so it's not case-sensitive to search items.
    final matchedItems = searchResults.where((result) => result.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Future.value(SearchResponse(success: true, searchResults: matchedItems));
  }
}