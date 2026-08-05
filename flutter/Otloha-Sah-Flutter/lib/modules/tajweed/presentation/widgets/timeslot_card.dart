import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/exam_reservation_bottom_sheet.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/onboard_page.dart';

class TimeSlotCard extends StatelessWidget {
  final TimeSlot timeSlot;

  const TimeSlotCard({
    super.key,
    required this.timeSlot,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => TimeslotCubit(timeSlot, false),
      child: BlocBuilder<TimeslotCubit, TimeSlotState>(
        builder: (context, state) {
          final DateFormat dateFormatter =
              DateFormat.yMMMMd(Localizations.localeOf(context).toString());
          final DateFormat timeFormatter =
              DateFormat.jm(Localizations.localeOf(context).toString());

          DateTime date = DateTime.parse(state.timeSlot.date);
          DateTime timeFrom = DateTime.parse(
              '${state.timeSlot.date} ${state.timeSlot.timeFrom}');
          DateTime timeTo =
              DateTime.parse('${state.timeSlot.date} ${state.timeSlot.timeTo}');

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: AppRadius.radiusSm,
                        ),
                        child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        dateFormatter.format(date),
                        style: AppTypography.h3Bold(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${timeFormatter.format(timeFrom)} - ${timeFormatter.format(timeTo)}',
                        style: AppTypography.bodySmall(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSlotInfo(tr('المجموع'), state.timeSlot.availableSlots, AppColors.info, isDark),
                      _buildSlotInfo(tr('المتبقي'), state.timeSlot.remainingSlots, AppColors.warning, isDark),
                      _buildSlotInfo(tr('المحجوز'), state.timeSlot.reservedSlots, AppColors.error, isDark),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: state.isReserved
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: AppRadius.radiusFull,
                                ),
                                child: Text(
                                  tr('محجوز بنجاح'),
                                  style: AppTypography.bodyMedium(color: AppColors.success).copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              OutlinedButton(
                                onPressed: () => context.read<TimeslotCubit>().cancelReservation(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
                                ),
                                child: Text(tr('إلغاء الحجز')),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.timeSlot.remainingSlots > 0
                                  ? () {
                                      if (UserDataServices.instance.getToken == null || UserDataServices.instance.getToken!.isEmpty) {
                                        Navigator.of(context).pushNamed(OnBoardPage.routeName);
                                      } else {
                                        _showReserveBottomSheet(context);
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                              ),
                              child: Text(
                                tr('حجز الموعد'),
                                style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotInfo(String label, int count, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySmall(color: color),
        ),
        const SizedBox(height: 2),
        Text(
          '$count',
          style: AppTypography.h3Bold(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  void _showReserveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext cxt) {
        final isDark = Theme.of(cxt).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(cxt).viewInsets.bottom + AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: AppRadius.radiusFull,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  tr('حجز موعد الاختبار'),
                  style: AppTypography.h2Bold(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ReservationBottomSheet(
                  onReserve: (String examType, String? notes) {
                    context.read<TimeslotCubit>().reserveSlot(
                          (context.read<LevelCardCubit>().state as LevelCardSelected).tajweedLevel.id,
                          examType,
                          notes,
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
