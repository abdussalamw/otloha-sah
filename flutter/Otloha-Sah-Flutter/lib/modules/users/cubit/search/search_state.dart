import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchInitialState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchFetchHistory extends SearchState {
  final List<String> terms;

  SearchFetchHistory({required this.terms});

  @override
  List<Object?> get props => [terms];
}

// class SearchFieldSubmitted

class SearchFieldSubmitted extends SearchState {
  final String term;

  SearchFieldSubmitted({required this.term});

  @override
  List<Object?> get props => [term];
}
