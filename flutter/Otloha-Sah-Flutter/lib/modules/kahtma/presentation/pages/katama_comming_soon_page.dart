import 'package:flutter/material.dart';

import '../../../../core/design_system/components/cards/app_card.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/widgets/tool_bar_app.dart';

class KhatmaCommingSoonPage extends StatelessWidget {
  const KhatmaCommingSoonPage({Key? key}) : super(key: key);

  static const String routeName = '/Khatma_comming_soon';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            ToolBarApp(
              backIcon: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: 'الختمة القرآنية',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: AppColors.primary,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'خدمة الختمة القرآنية',
                          style: AppTypography.h2Bold(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'تتيح لك إمكانية متابعة ختمة القرآن الكريم ومشاركتها مع معلميك وأصدقائك بأسلوب تفاعلي عصري .. سيتم إطلاقها قريباً بإذن الله',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
