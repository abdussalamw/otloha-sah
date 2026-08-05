import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../core/design_system/components/cards/app_card.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import '../../business_logic/narration/narration_cubit.dart';
import '../../business_logic/themes/theme_cubit.dart';
import '../widgets/change_narration.dart';
import 'settings/about_us_page.dart';
import 'settings/contact_us_page.dart';
import 'settings/recitation_page.dart';
import 'settings/tafseer_page.dart';
import 'settings/tajweed_page.dart';
import 'settings/quran_translation_language_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            ToolBarApp(
              backIcon: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: translate('Settings'),
            ),

            // Modern Compact Settings List
            Expanded(
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // 1. App Language (لغة التطبيق - مع التحديث الفوري)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.language_rounded,
                        title: 'لغة التطبيق (Language)',
                        actionWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildChoiceChip(
                              context,
                              label: 'العربية',
                              isSelected: context.locale.languageCode == 'ar',
                              onTap: () async {
                                if (context.locale.languageCode != 'ar') {
                                  await context.setLocale(const Locale('ar'));
                                  Get.updateLocale(const Locale('ar'));
                                  setState(() {});
                                }
                              },
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            _buildChoiceChip(
                              context,
                              label: 'English',
                              isSelected: context.locale.languageCode == 'en',
                              onTap: () async {
                                if (context.locale.languageCode != 'en') {
                                  await context.setLocale(const Locale('en'));
                                  Get.updateLocale(const Locale('en'));
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 2. App Theme (المظهر)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.dark_mode_rounded,
                        title: 'المظهر (Theme)',
                        actionWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildChoiceChip(
                              context,
                              label: '☀️ نهاري',
                              isSelected: !ThemeCubit.isDark,
                              onTap: () {
                                if (ThemeCubit.isDark) {
                                  ThemeCubit.get(context).changeTheme();
                                }
                              },
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            _buildChoiceChip(
                              context,
                              label: '🌙 ليلي',
                              isSelected: ThemeCubit.isDark,
                              onTap: () {
                                if (!ThemeCubit.isDark) {
                                  ThemeCubit.get(context).changeTheme();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 3. Quran Narration (الرواية القرآنية - منسدلة بدلاً من صفحة جديدة)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.menu_book_rounded,
                        title: 'الرواية القرآنية',
                        subtitle: SettingsMenusData.safeTranslate(
                          QuranCacheRepository.narrationSelectedName,
                        ),
                        actionWidget: _buildChoiceChip(
                          context,
                          label: SettingsMenusData.safeTranslate(
                            QuranCacheRepository.narrationSelectedName,
                          ).isNotEmpty
                              ? SettingsMenusData.safeTranslate(
                                  QuranCacheRepository.narrationSelectedName,
                                )
                              : 'اختر الرواية',
                          isSelected: true,
                          onTap: () => _showNarrationBottomSheet(context),
                        ),
                        onTap: () => _showNarrationBottomSheet(context),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 4. Preferred Reciter (القارئ المفضل)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.record_voice_over_rounded,
                        title: 'القارئ المفضل',
                        subtitle: SettingsMenusData.safeTranslate(
                          QuranCacheRepository.selectedRecitationName,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(RecitationPage.routeName).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 5. Tafseer (التفسير المعتمد)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.auto_stories_rounded,
                        title: 'التفسير المعتمد',
                        subtitle: SettingsMenusData.safeTranslate(
                          QuranCacheRepository.tafsirSelectedName,
                        ),
                        actionWidget: _buildChoiceChip(
                          context,
                          label: SettingsMenusData.safeTranslate(
                            QuranCacheRepository.tafsirSelectedName,
                          ).isNotEmpty
                              ? SettingsMenusData.safeTranslate(
                                  QuranCacheRepository.tafsirSelectedName,
                                )
                              : 'التفسير الميسر',
                          isSelected: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(TafseerPage.routeName).then((_) => setState(() {}));
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(TafseerPage.routeName).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 6. Translation (ترجمة المعاني)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.g_translate_rounded,
                        title: 'ترجمة المعاني',
                        subtitle: SettingsMenusData.safeTranslate(
                          QuranCacheRepository.quranTranslationSelectedName,
                        ),
                        actionWidget: _buildChoiceChip(
                          context,
                          label: SettingsMenusData.safeTranslate(
                            QuranCacheRepository.quranTranslationSelectedName,
                          ).isNotEmpty
                              ? SettingsMenusData.safeTranslate(
                                  QuranCacheRepository.quranTranslationSelectedName,
                                )
                              : 'English',
                          isSelected: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(QuranTranslationLanguagePage.routeName).then((_) => setState(() {}));
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(QuranTranslationLanguagePage.routeName).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 7. Tajweed Rules (أحكام التجويد)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.school_rounded,
                        title: 'أحكام التجويد',
                        subtitle: SettingsMenusData.getTajweedName(),
                        actionWidget: _buildChoiceChip(
                          context,
                          label: SettingsMenusData.getTajweedName().isNotEmpty
                              ? SettingsMenusData.getTajweedName()
                              : 'التجويد الميسر',
                          isSelected: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(TajweedPage.routeName).then((_) => setState(() {}));
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(TajweedPage.routeName).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 8. Contact & Support (التواصل والدعم الفني)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.support_agent_rounded,
                        title: 'التواصل والدعم الفني',
                        onTap: () {
                          Get.to(() => const ContactUsPage());
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 9. About App & Awqaf (عن التطبيق والأوقاف)
                      _buildSingleLineSettingRow(
                        context,
                        icon: Icons.info_outline_rounded,
                        title: 'عن تطبيق اتلوها صح والأوقاف',
                        onTap: () {
                          Get.to(() => const AboutUsPage());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Narration Bottom Sheet (منسدلة اختيار الرواية القرآنية)
  void _showNarrationBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(parentContext).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom Sheet Drag Indicator
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: AppRadius.radiusFull,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'اختر الرواية القرآنية',
                    style: AppTypography.h3Bold(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),

              // Narrations List from Cubit
              BlocProvider(
                create: (context) => NarrationCubit()..fetchNarration(),
                child: BlocBuilder<NarrationCubit, NarrationState>(
                  builder: (context, state) {
                    if (state is NarrationFetched || state is NarrationChangeSelected) {
                      final cubit = BlocProvider.of<NarrationCubit>(context);
                      final narrations = cubit.narrations ?? [];
                      final selectedIndex = cubit.selected ?? 0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(narrations.length, (index) {
                          final narration = narrations[index];
                          final isSelected = selectedIndex == index;
                          final name = narration.name.translate().toString();

                          return AppCard(
                            onTap: () {
                              cubit.changeSelected(index);
                              Get.dialog(
                                ChangeNarrtionPopup(narration: narration),
                              ).then((_) {
                                Navigator.pop(context);
                                parentContext.findAncestorStateOfType<_SettingsPageState>()?.setState(() {});
                              });
                            },
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: isSelected ? AppColors.primary : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      name,
                                      style: AppTypography.bodyMedium(
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ).copyWith(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  )
                                else
                                  const Icon(
                                    Icons.radio_button_unchecked_rounded,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                              ],
                            ),
                          );
                        }),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  // Single-Line Setting Card Widget
  Widget _buildSingleLineSettingRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? actionWidget,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (actionWidget != null)
            actionWidget
          else
            Icon(
              Icons.chevron_left_rounded,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
        ],
      ),
    );
  }

  // Choice Chip Widget for Single-Line Selectors
  Widget _buildChoiceChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall(
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
          ).copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
