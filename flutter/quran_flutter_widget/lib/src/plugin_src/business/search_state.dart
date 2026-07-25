import 'package:quran_widget_flutter/model/search.dart';

abstract class SearchState {
  const SearchState();
}

class SearchStateInitial extends SearchState {
  const SearchStateInitial();
}

class SearchStateLoading extends SearchState {
  const SearchStateLoading();
}

class SearchStateError extends SearchState {
  const SearchStateError();
}

class SearchStateSuccess extends SearchState {
  final List<Search> searchResults;
  const SearchStateSuccess({required this.searchResults});
}

class SearchStateEmpty extends SearchState {
  const SearchStateEmpty();
}
