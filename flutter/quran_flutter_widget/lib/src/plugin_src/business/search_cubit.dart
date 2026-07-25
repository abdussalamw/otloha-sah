import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/remote/search.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchStateInitial());

  static SearchCubit get(BuildContext context) =>
      BlocProvider.of<SearchCubit>(context);
  Future<void> search(String query) async {
    emit(const SearchStateLoading());
    final searchResults = await SearchApi().fetchSearchList(query);
    if (searchResults.data.isEmpty) {
      emit(const SearchStateEmpty());
    } else if (searchResults.code == 200) {
      emit(SearchStateSuccess(searchResults: searchResults.data));
    } else {
      emit(const SearchStateError());
    }
  }
}
