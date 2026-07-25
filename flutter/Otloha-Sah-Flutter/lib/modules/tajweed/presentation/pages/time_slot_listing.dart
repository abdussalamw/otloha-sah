import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/timeslot_card.dart';

class TimeSlotsListingPage extends StatelessWidget {
  const TimeSlotsListingPage({super.key});

  static const route = 'remainingTimeSlotPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          tr('Timeslots'),
        ),
        centerTitle: true,
        elevation: 8.0,
      ),
      body: PaginationData<TimeSlot>(
        initData: const [],
        getData: (next) {
          return ApiBaseHelper().getHTTP(
            '/api/v1/tajweed/exam-reservations/remaining_slots/',
            dioTypes: DioTypes.authRequired,
          );
        },
        drowItem: (timeslot, idx) => TimeSlotCard(
          timeSlot: timeslot,
        ),
        pagingController: PagingController<int, TimeSlot>(firstPageKey: 1),
      ),
    );
  }
}
