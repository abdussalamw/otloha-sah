import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/models/room/room.dart';
import 'dart:async';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());

  static RoomsCubit get(BuildContext context) => BlocProvider.of(context);
  List<Room> data = [];
  late PagingController pageContlloer;

  setPageController(PagingController controller) {
    pageContlloer = controller;
  }

  Future getRooms({bool withLoading = true}) async {
    if (withLoading) {
      emit(RoomsLoadingDataState());
    }
    try {
      Response? listRooms = await AppDataSource().roomListing();
      if (listRooms != null &&
          listRooms.statusCode == 200 &&
          listRooms.data != null) {
        List<Room>? data = (listRooms.data['results'] as List)
            .map(
              (room) => Room.fromJson(room),
            )
            .toList();

        if (data.isNotEmpty) {
          if (!withLoading) {
            pageContlloer.itemList = data;
          }
          emit(RoomsFetechedDataState(data: data));
        } else {
          emit(RoomsErrorState(exception: EmptyListException()));
        }
      }
    } catch (e) {
      emit(RoomsErrorState(exception: e));
    }
  }

  fetchNextPage(int next) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/chat/recitation/?page=$next',
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }
}
