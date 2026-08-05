import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h3Bold(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String label, {
    Function()? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

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
                title: 'التواصل والدعم الفني',
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildCard(
                      context,
                      title: 'معلومات التواصل المباشر',
                      children: [
                        _buildInfoTile(
                          context,
                          Icons.location_on_rounded,
                          'أكاديمية أوقاف الشيخ محمد بن عبدالعزيز الراجحي',
                          onTap: () => _launchURL('https://maps.app.goo.gl/ZyE4Mt5ZvtiNUmmk6'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.phone_rounded,
                          '+966533422404',
                          onTap: () => _launchURL('tel:+966533422404'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.email_rounded,
                          'RAcademy@qj.org.sa',
                          onTap: () => _launchURL('mailto:RAcademy@qj.org.sa'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.mail_outline_rounded,
                          'mbnoob@qj.org.sa',
                          onTap: () => _launchURL('mailto:mbnoob@qj.org.sa'),
                        ),
                      ],
                    ),
                    _buildCard(
                      context,
                      title: 'قنوات التواصل الاجتماعي',
                      children: [
                        _buildInfoTile(
                          context,
                          Icons.video_library_rounded,
                          'قناة اليوتيوب الرسمية',
                          onTap: () => _launchURL('https://www.youtube.com/user/khayrocom'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.camera_alt_rounded,
                          'انستجرام',
                          onTap: () => _launchURL('https://www.instagram.com/khayrocom/'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.facebook_rounded,
                          'فيسبوك',
                          onTap: () => _launchURL('https://www.facebook.com/khayrocom'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.alternate_email_rounded,
                          'حساب منصة X (تويتر)',
                          onTap: () => _launchURL('https://x.com/khayrocom'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.volunteer_activism_rounded,
                          'منصة التبرعات والأوقاف',
                          onTap: () => _launchURL('https://qjstore.org.sa/projects'),
                        ),
                      ],
                    ),
                    _buildCard(
                      context,
                      title: 'خدمات جمعية خيركم التعليمية',
                      children: [
                        _buildInfoTile(
                          context,
                          Icons.apps_rounded,
                          'عرض وتنزيل جميع التطبيقات المتاحة',
                          onTap: () => _launchURL('https://alrajhiacademy.com/ar/services'),
                        ),
                        _buildInfoTile(
                          context,
                          Icons.language_rounded,
                          'منصة جمعية خيركم الرسمية',
                          onTap: () => _launchURL('https://qjstore.org.sa/'),
                        ),
                      ],
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
}
