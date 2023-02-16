import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_example/data/search_repository.dart';
import 'package:search_example/search/search_event.dart';
import 'package:search_example/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchRepository _searchRepo;
  final BehaviorSubject<String> _searchSubject = BehaviorSubject();

  Stream<String> get _searchStream => _searchSubject.stream;

  SearchBloc({required SearchRepository repo, int searchWaitTime = 500}) : super(SearchInitial()) {
    _searchRepo = repo;
    _listenForSearches(searchWaitTime: searchWaitTime);

    on<SearchChanged>((event, emit) async {
      if (event.searchQuery.isEmpty) {
        emit(SearchInitial());
        return;
      }
      _searchSubject.add(event.searchQuery);
    });

    on<SearchStopped>((event, emit) async {
      emit(SearchLoadingState());
    });

    on<SearchComplete>((event, emit) async {
      if (event.searchResults.isEmpty) {
        emit(SearchNoItems());
        return;
      }

      emit(SearchLoaded(searchResults: event.searchResults));
    });

    on<SearchLoadError>((event, emit) async {
      emit(SearchError());
    });
  }

  void _listenForSearches({required int searchWaitTime}) {
    _searchStream
    // When someone searches we wait half a second before processing the search.
    // We do this to limit queries to the server.
        .debounceTime(Duration(milliseconds: searchWaitTime))
        .doOnData((_) => add(SearchStopped()))
        .doOnError((_, __) => add(SearchLoadError()))
        .asyncMap((query) async =>
            await _searchRepo.fetchSearchResults(searchQuery: query))
        .listen((response) {
          if (!response.success) {
            add(SearchLoadError());

            return;
          }

          add(SearchComplete(searchResults: response.searchResults));
    });
  }
}
