import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservedExamCard extends StatelessWidget {
  final ReservedTimeslot examReservation;

  const ReservedExamCard({
    super.key,
    required this.examReservation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final DateFormat dateFormatter =
        DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    final DateFormat timeFormatter =
        DateFormat.jm(Localizations.localeOf(context).toString());

    DateTime date = DateTime.parse(examReservation.calendarSlot.date);
    DateTime timeFrom = DateTime.parse(
        '${examReservation.calendarSlot.date} ${examReservation.calendarSlot.timeFrom}');
    DateTime timeTo = DateTime.parse(
        '${examReservation.calendarSlot.date} ${examReservation.calendarSlot.timeTo}');

    return BlocBuilder<TimeslotCubit, TimeSlotState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Date and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: AppRadius.radiusSm,
                          ),
                          child: const Icon(Icons.event_available_rounded, color: AppColors.primary, size: 20),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.quranGold.withOpacity(0.15),
                        borderRadius: AppRadius.radiusFull,
                        border: Border.all(color: AppColors.quranGold),
                      ),
                      child: Text(
                        examReservation.status,
                        style: AppTypography.bodySmall(color: AppColors.quranGold).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Time Slot info
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight, size: 18),
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

                // Level and Exam Type Details
                _buildInfoRow(
                  icon: Icons.school_outlined,
                  label: tr('مستوى التجويد'),
                  value: examReservation.level.name.translate() ?? '',
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildInfoRow(
                  icon: Icons.assignment_outlined,
                  label: tr('نوع الاختبار'),
                  value: tr(examReservation.examType),
                  isDark: isDark,
                ),
                if (examReservation.notes != null && examReservation.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildInfoRow(
                    icon: Icons.notes_rounded,
                    label: tr('ملاحظات'),
                    value: examReservation.notes!,
                    isDark: isDark,
                  ),
                ],

                // Meeting Link if available
                if (examReservation.meetingLink != null && examReservation.meetingLink!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(examReservation.meetingLink!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    borderRadius: AppRadius.radiusSm,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: AppRadius.radiusSm,
                        border: Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.video_call_rounded, color: AppColors.info, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            tr('رابط التسميع المباشر (Zoom / Meet)'),
                            style: AppTypography.bodyMedium(color: AppColors.info).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Cancel Button
                if (state.isReserved) ...[
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<TimeslotCubit>().cancelReservation(
                              examReservation: examReservation,
                            );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                      ),
                      child: Text(tr('إلغاء حجز الاختبار')),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label: ',
          style: AppTypography.bodySmall(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ).copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
