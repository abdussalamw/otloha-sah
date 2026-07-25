import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_recieved_list/invitation_recieved_list_state.dart';

class InvitationRecievedCubit extends Cubit<InvitationRecievedListState> {
  InvitationRecievedCubit() : super(InvitationRecievedListInitialState());

  late SearchController searchController;
  setSearchController(SearchController controller) {
    searchController = controller;
  }

  getNextPage(int nextLink) async {
    Response? response;
    String link = '';
    link = '/api/v1/invitations/request_received/';

    response = await ApiBaseHelper().getHTTP(
      link,
      queryParameters: {
        'page': nextLink,
        'q': searchController.text,
        'status': 'pending'
      },
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }
}
