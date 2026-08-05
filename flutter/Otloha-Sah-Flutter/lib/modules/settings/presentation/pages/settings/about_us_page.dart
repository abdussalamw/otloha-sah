import 'package:flutter/material.dart';

import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_shadows.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
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
                title: 'عن تطبيق اتلوها صح',
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Header Brand Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/LOGO_500.gif',
                            width: 80,
                            height: 80,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.auto_stories_rounded,
                              color: AppColors.primary,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'تطبيق اتلوها صح',
                            style: AppTypography.h2Bold(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'الإصدار v4 - تطوير حلول وبدائل لتقنية المعلومات',
                            style: AppTypography.bodySmall(color: AppColors.primary).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'بدعم ورعاية أوقاف الشيخ محمد بن عبدالعزيز الراجحي لتعليم القرآن الكريم\nوإشراف جمعية خيركم لتحفيظ القرآن الكريم بجدة',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // About Project Section Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ما هو مشروع اتلوها صح؟',
                            style: AppTypography.h3Bold(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Divider(),
                          Text(
                            'مشروع عالمي فريد يهدف لتعليم تلاوة القرآن الكريم صوتياً وتصحيح التلاوات باستخدام التقنيات الحديثة، يتيح لك تعلم القرآن وتصحيح التلاوة وإتقان أحكام التجويد من خلال دروس نظرية وتطبيقية تفاعلية مع معلمين مختصين ومجازين.',
                            style: AppTypography.bodyMedium(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Features Section Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مميزات وخصائص التطبيق المحدثة:',
                            style: AppTypography.h3Bold(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Divider(),
                          _buildFeatureBullet(context, 'عرض صفحات المصحف الشريف الكريمة ورسمها المعروض بالكامل.'),
                          _buildFeatureBullet(context, 'تصحيح وتصحيح التلاوة المباشرة مع المعلمين المعتمَدين.'),
                          _buildFeatureBullet(context, 'تسجيل وحفظ مصحف كامل بصوت المستخدم الشخصي.'),
                          _buildFeatureBullet(context, 'مشاركة التلاوات المتميزة والتصحيحات مع الآخرين.'),
                          _buildFeatureBullet(context, 'التفسير الميسر وترجمات المعاني المتعددة.'),
                          _buildFeatureBullet(context, 'تعلم التجويد التحليلي بطرق احترافية وتفاعلية.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBullet(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
