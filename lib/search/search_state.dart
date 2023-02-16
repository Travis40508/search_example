
import 'package:search_example/models/search_result.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}
class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}
class SearchNoItems extends SearchState {
  @override
  List<Object?> get props => [];
}
class SearchLoaded extends SearchState {
  final List<SearchResult> searchResults;

  SearchLoaded({
    required this.searchResults,
  });

  SearchLoaded copyWith({
    List<SearchResult>? searchResults,
  }) {
    return SearchLoaded(
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object?> get props => [
    searchResults,
  ];
}
class SearchError extends SearchState {
  @override
  List<Object?> get props => [];
}