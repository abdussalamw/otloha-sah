import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/entities_list_cubit/entities_list_state.dart';

class EntitiesListCubit extends Cubit<EntitiesListingState> {
  final PagingController<int, Entity> pagingController;
  EntitiesListCubit({
    required this.pagingController,
  }) : super(EntitiesListingLoading());

  late SearchController searchController;

  setSearchController(SearchController controller) {
    searchController = controller;
  }

  getNextPage(int nextLink) async {
    Response? response;
    String link = '';
    link = '/api/v2/users-profiles/entities/';

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
