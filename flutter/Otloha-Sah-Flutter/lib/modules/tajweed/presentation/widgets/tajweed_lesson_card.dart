import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/lesson_page.dart';

class TajweedLessonCard extends StatelessWidget {
  const TajweedLessonCard({
    super.key,
    required this.tajweedLesson,
  });

  final TajweedLesson tajweedLesson;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double progress = (tajweedLesson.numberOfChildren > 0)
        ? (tajweedLesson.completedLessons / tajweedLesson.numberOfChildren).clamp(0.0, 1.0)
        : 0.0;
    final int remaining = (tajweedLesson.numberOfChildren - tajweedLesson.completedLessons).clamp(0, 999);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () {
        Navigator.pushNamed(
          context,
          LessonPage.routeName,
          arguments: tajweedLesson,
        );
      },
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Lesson Details & Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tajweedLesson.title.translate() ?? '',
                  style: AppTypography.bodyLarge(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Progress Bar
                ClipRRect(
                  borderRadius: AppRadius.radiusFull,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    color: AppColors.quranGold,
                  ),
                ),
                const SizedBox(height: 4),

                // Remaining parts info
                Text(
                  '${tr('You need')} $remaining ${tr('parts to pass')}',
                  style: AppTypography.caption(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.xs),

          // Chevron Arrow
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ],
      ),
    );
  }
}
