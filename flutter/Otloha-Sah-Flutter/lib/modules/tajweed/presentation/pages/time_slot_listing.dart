import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/timeslot_card.dart';

class TimeSlotsListingPage extends StatelessWidget {
  const TimeSlotsListingPage({super.key});

  static const route = 'remainingTimeSlotPage';
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: tr('مواعيد الاختبارات المتاحة'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  child: PaginationData<TimeSlot>(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
