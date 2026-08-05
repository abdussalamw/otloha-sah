import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/reserved_exam_card.dart';

class ReservedExamsListing extends StatelessWidget {
  const ReservedExamsListing({super.key});
  static const String route = 'ReservedExamsListing';

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
                title: tr('الاختبارات المحجوزة'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  child: PaginationData<ReservedTimeslot>(
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
                    pagingController: PagingController<int, ReservedTimeslot>(firstPageKey: 1),
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
