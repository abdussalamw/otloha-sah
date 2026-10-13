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
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/login_page.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/reserved_exam_card.dart';

class ReservedExamsListing extends StatelessWidget {
  const ReservedExamsListing({super.key});
  static const String route = 'ReservedExamsListing';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!UserDataServices.instance.isLogin) {
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event_busy_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'تسجيل الدخول مطلوب',
                            style: AppTypography.h3Small(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'يرجى تسجيل الدخول للوصول إلى قائمة اختبارات التجويد المحجوزة الخاصة بك.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                            ),
                            icon: const Icon(Icons.login_rounded),
                            label: const Text('تسجيل الدخول الآن'),
                            onPressed: () {
                              Navigator.pushNamed(context, LoginPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
