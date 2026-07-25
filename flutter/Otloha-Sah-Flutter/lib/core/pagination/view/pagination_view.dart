import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_recieved.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../data_source/models/room/room.dart';
import '../../error/exceptions.dart';
import '../../exception_indicators/error_indicator.dart';
import '../../../data_source/models/message_model/general_response.dart';
import '../../../data_source/models/message_model/message_model.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data_source/models/notifications_model/notifications_model.dart';

final factories = <Type, Function>{
  GeneralResponse: (Map<String, dynamic> data) =>
      GeneralResponse.fromJson(data),
  // Recitations: (Map<String, dynamic> data) => Recitations.fromJson(data),
  MessageModel: (Map<String, dynamic> data) => MessageModel.fromMap(data),
  Recitation: (Map<String, dynamic> data) => Recitation.fromJson(data),
  User: (Map<String, dynamic> data) => User.fromJson(data),
  NotificationsModel: (Map<String, dynamic> data) =>
      NotificationsModel.fromMap(data),
  Room: (Map<String, dynamic> data) => Room.fromJson(data),
  BaseUser: (Map<String, dynamic> data) => BaseUser.fromMap(data),
  Entity: (Map<String, dynamic> data) => Entity.fromMap(data),
  Student: (Map<String, dynamic> data) => Student.fromMap(data),
  Teacher: (Map<String, dynamic> data) => Teacher.fromMap(data),
  InvitationRecieved: (Map<String, dynamic> data) =>
      InvitationRecieved.fromMap(data),
  BlockedUser: (Map<String, dynamic> data) => BlockedUser.fromMap(data),
  TajweedLevel: (Map<String, dynamic> data) => TajweedLevel.fromMap(data),
  TajweedLesson: (Map<String, dynamic> data) => TajweedLesson.fromMap(data),
  TimeSlot: (Map<String, dynamic> data) => TimeSlot.fromJson(data),
  ReservedTimeslot: (Map<String, dynamic> data) =>
      ReservedTimeslot.fromMap(data),
};

class PaginationData<T> extends StatefulWidget {
  const PaginationData({
    super.key,
    required this.initData,
    required this.getData,
    required this.drowItem,
    required this.pagingController,
    this.scrollDirection = Axis.vertical,
    this.gridDelegate,
    this.isGrid = false,
  });

  final List<T> initData;

  final SliverGridDelegate? gridDelegate;

  final Future<Response?>? Function(int) getData;
  final Widget Function(T, int) drowItem;
  final PagingController pagingController;
  final Axis scrollDirection;
  final bool isGrid;

  @override
  State<PaginationData<T>> createState() => _PaginationDataState<T>();
}

class _PaginationDataState<T> extends State<PaginationData<T>> {
  get con => widget.pagingController;

  int page = 1;
  bool isFirst = true;

  @override
  void initState() {
    con.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int? pageKey) async {
    try {
      Response? response = await widget.getData(pageKey ?? 1);

      // print('response.data[\'next\'] ${response!.data['next']}');

      final isLastPage = (response!.data['next'] == null ||
          response.data['next'].toString().isEmpty);

      List<T> itemsNew = (response.data['results'] as List)
          .map<T>((map) => factories[T]?.call(map))
          .toList();
      if (isLastPage) {
        con.appendLastPage(itemsNew);
      } else {
        page++;
        con.appendPage(itemsNew, page);
      }
    } catch (error, s) {
      print('PaginationData ${widget.initData}');
      print(error);
      print(s);

      if (con.itemList == null || con.itemList!.isEmpty) {
        if (widget.initData.isEmpty) {
          con.error = error;
        } else {
          con.itemList = widget.initData;
        }
      }
      // else {
      //   con.error = error;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () {
          page = 1;
          con.refresh();
        },
      ),
      child: widget.isGrid ? _viewGrid() : _viewList(),
    );
  }

  PagedGridView<int, T> _viewGrid() {
    return PagedGridView<int, T>(
      pagingController: con,
      addAutomaticKeepAlives: true,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, index) => widget.drowItem(item, index),
        firstPageErrorIndicatorBuilder: (error) {
          return ErrorIndicator(
            error: con.error,
            onTryAgain: con.refresh,
          );
        },
      ),
      gridDelegate: widget.gridDelegate ??
          const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 2,
          ),
    );
  }

  PagedListView<int, dynamic> _viewList() {
    return PagedListView<int, T>(
      pagingController: con,
      scrollDirection: widget.scrollDirection,
      addAutomaticKeepAlives: true,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, index) => widget.drowItem(item, index),
        firstPageErrorIndicatorBuilder: (error) {
          return Center(
            child: ErrorIndicator(
              error: con.error,
              onTryAgain: con.refresh,
            ),
          );
        },
        newPageErrorIndicatorBuilder: (error) {
          return Center(
            child: ErrorIndicator(
              error: EmptyListException(),
              onTryAgain: con.refresh,
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (error) {
          return Center(
            child: ErrorIndicator(
              error: EmptyListException(),
            ),
          );
        },
      ),
    );
  }
}
