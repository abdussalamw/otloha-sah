import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/reserved_exams_listing.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/time_slot_listing.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/login_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.level,
  });

  final TajweedLevel level;

  @override
  Widget build(BuildContext context) {
    final isSelected = context.watch<LevelCardCubit>().state is LevelCardSelected;
    final double percent = (level.completed.clamp(0, 100)) / 100.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.radiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          CircularPercentIndicator(
            radius: 36.0,
            lineWidth: 8.0,
            percent: percent,
            animation: true,
            center: Text(
              '${(level.completed).ceil()}%',
              style: AppTypography.bodyLarge(color: AppColors.quranGold).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            progressColor: AppColors.quranGold,
            backgroundColor: Colors.white.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
          ),

          const SizedBox(width: AppSpacing.md),

          // Title & Exam Action Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  level.name.translate() ?? '',
                  style: AppTypography.h3Small(color: Colors.white).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                if (isSelected)
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.quranGold,
                          foregroundColor: AppColors.primaryDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
                          minimumSize: const Size(0, 32),
                        ),
                        onPressed: () {
                          if (!UserDataServices.instance.isLogin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'يلزم تسجيل الدخول لحجز أو إجراء اختبار التجويد النهائي',
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                                action: SnackBarAction(
                                  label: 'تسجيل الدخول',
                                  onPressed: () {
                                    Navigator.pushNamed(context, LoginPage.routeName);
                                  },
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.pushNamed(context, TimeSlotsListingPage.route);
                        },
                        child: Text(
                          local.tr('Take exam'),
                          style: AppTypography.caption(color: AppColors.primaryDark).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
                          minimumSize: const Size(0, 32),
                        ),
                        onPressed: () {
                          if (!UserDataServices.instance.isLogin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'يلزم تسجيل الدخول لعرض اختباراتك المحجوزة',
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                                action: SnackBarAction(
                                  label: 'تسجيل الدخول',
                                  onPressed: () {
                                    Navigator.pushNamed(context, LoginPage.routeName);
                                  },
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.pushNamed(context, ReservedExamsListing.route);
                        },
                        child: Text(
                          local.tr('My Exams'),
                          style: AppTypography.caption(color: Colors.white).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
