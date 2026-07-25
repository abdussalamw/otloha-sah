import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/search/search_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/search/search_state.dart';

import '../../../../core/network/api_base_helper.dart';

part 'students_list_state.dart';

class StudentsListCubit extends Cubit<StudentsListState> {
  final PagingController<int, Student> pagingController;
  final SearchCubit searchCubit;
  late final StreamSubscription streamSubscription;

  late SearchController searchController;

  static StudentsListCubit cubit(context) =>
      BlocProvider.of<StudentsListCubit>(context);

  StudentsListCubit({
    required this.pagingController,
    required this.searchCubit,
  }) : super(StudentsListInitial()) {
    streamSubscription = searchCubit.stream.listen((event) {
      if (event is SearchFieldSubmitted) {
        pagingController.refresh();
      }
    });
  }

  setSearchController(SearchController controller) {
    searchController = controller;
  }

  getNextPage(int nextLink) async {
    Response? response;
    String link = '';
    link = '/api/v2/users-profiles/students/';

    response = await ApiBaseHelper().getHTTP(
      link,
      queryParameters: {
        'page': nextLink,
        'q': searchController.text,
        'ordering': '-rate'
      },
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }

  removeItemFromList(int userId) {
    pagingController.itemList = pagingController.itemList!
        .where((element) => element.id != userId)
        .toList();
  }

  // @override
  // Future<void> close() {
  //   streamSubscription.cancel();
  //   return super.close();
  // }
}
