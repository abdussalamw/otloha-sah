import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  Set<String> terms = {};
  String term = '';

  // getSearchTerms() async {
  //   terms = json
  //       .decode(CacheHelper.getData(key: 'search_history') ?? '[]')
  //       .toSet() as Set<String>;
  // }

  updateSearchTerm(String term) {
    this.term = term;
    // SearchController searchController = SearchController();
    // searchController.
    // emit()
  }

  search() {
    terms.add(term);
    print('asdasd');
    emit(SearchFieldSubmitted(term: term));
    // CacheHelper.saveData(
    //     key: 'search_history', value: json.encode(terms.toList()));
  }
}
