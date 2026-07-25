import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/reserved_exam_card.dart';

class ReservedExamsListing extends StatelessWidget {
  const ReservedExamsListing({super.key});
  static const String route = 'ReservedExamsListing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Reserved Exam Listing'),
        ),
        centerTitle: true,
        elevation: 8.0,
      ),
      body: PaginationData<ReservedTimeslot>(
        initData: const [],
        getData: (next) {
          return ApiBaseHelper().getHTTP(
            '/api/v1/tajweed/exam-reservations/',
            dioTypes: DioTypes.authRequired,
          );
        },
        drowItem: (timeslot, idx) => BlocProvider(
          create: (context) => TimeslotCubit(timeslot.calendarSlot, true),
          child: ReservedExamCard(
            examReservation: timeslot,
          ),
        ),
        pagingController:
            PagingController<int, ReservedTimeslot>(firstPageKey: 1),
      ),
    );
  }
}
