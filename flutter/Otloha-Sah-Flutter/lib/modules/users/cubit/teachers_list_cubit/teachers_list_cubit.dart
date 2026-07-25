import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

part 'teachers_list_state.dart';

class TeachersListCubit extends Cubit<TeachersListState> {
  final PagingController<int, BaseUser> pagingController;

  TeachersListCubit({required this.pagingController})
      : super(TeachersListInitial());

  late SearchController searchController;

  setSearchController(SearchController controller) {
    searchController = controller;
  }

  getNextPage(int nextLink) async {
    Response? response;
    String link = '';
    link = '/api/v2/users-profiles/teachers/';

    response = await ApiBaseHelper().getHTTP(
      link,
      queryParameters: {'page': nextLink, 'q': searchController.text},
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }

  removeItemFromList(int userId) {
    pagingController.itemList = pagingController.itemList!
        .where((element) => element.id != userId)
        .toList();
  }
}
