import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

part 'my_students_state.dart';

class MyStudentsCubit extends Cubit<MyStudentsState> {
  MyStudentsCubit({required this.pagingController})
      : super(MyStudentsInitial());

  late SearchController searchController;

  setSearchController(SearchController controller) {
    searchController = controller;
  }

  final PagingController<int, BaseUser> pagingController;
  getNextPage(int nextLink) async {
    Response? response;
    String link = '';
    link = '/api/v2/my-profile/students/';

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
