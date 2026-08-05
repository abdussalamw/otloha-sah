import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;

import '../../../../../app_router.dart';
import '../../../../../core/design_system/components/cards/app_card.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_radius.dart';
import '../../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/widgets/auth_navigator.dart';
import '../../../../../core/widgets/cached_image.dart';
import '../../../../../core/widgets/user_avatar_widget.dart';
import '../../../../profile/business_logic/profile_pic_cubit/update_profile_cubit.dart';
import '../../../../profile/business_logic/profile_pic_cubit/update_profile_state.dart';
import '../../../../profile/presentation/page/profile_bnb_page.dart';
import '../../../../quran/presentation/page/action_pages/bookmark_bage.dart';
import '../../../../quran/presentation/page/action_pages/note_page.dart';
import '../../../../quran/presentation/page/action_pages/pages_liked_page.dart';
import '../../../../recitations/presentation/page/recitations_page.dart';
import '../../../../settings/presentation/pages/settings/about_us_page.dart';
import '../../../../settings/presentation/pages/settings/contact_us_page.dart';
import '../../../../settings/presentation/pages/settings/how_it_works_page.dart';
import '../../../../settings/presentation/pages/settings_page.dart';
import '../../../../splash/business_logic/cubit/splash_cubit.dart';
import '../../../../teachers/presentation/page/students_page.dart';
import '../../../../users/presentation/pages/users_listing.dart';

class HomeBNBPage extends StatefulWidget {
  const HomeBNBPage({super.key});

  @override
  State<HomeBNBPage> createState() => _HomeBNBPageState();
}

class _HomeBNBPageState extends State<HomeBNBPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (SplashCubit.user == null) {
        SplashCubit.get(context).getInitDate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Header Card (User, Settings, & Stats)
                _buildHeaderCard(context, isDark),

                const SizedBox(height: 4),

                // 2. Group 1: Quran Tools (ملاحظاتي - الآيات المفضلة - فواصل المصحف)
                _buildGroupCard(
                  context,
                  title: 'أدوات القرآن الكريم',
                  isDark: isDark,
                  children: [
                    _buildIconItem(
                      context,
                      title: translate('Note'),
                      icon: Icons.edit_note_rounded,
                      color: const Color(0xFF007AFF),
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        NotesVersePage.routeName,
                        arguments: 1,
                      ),
                    ),
                    _buildIconItem(
                      context,
                      title: translate('Likes'),
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFFFF2D55),
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        LikedVersesPage.routeName,
                      ),
                    ),
                    _buildIconItem(
                      context,
                      title: translate('BookMarks'),
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFFFF9500),
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        PagesBookMarkPage.routeName,
                        arguments: 2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 3. Group 2: Recitations & Community (تسجيلاتي - المحادثات - تلاوات المعلمين - المستخدمين)
                _buildGroupCard(
                  context,
                  title: 'التلاوات والتواصل',
                  isDark: isDark,
                  children: [
                    _buildIconItem(
                      context,
                      title: translate('my_records'),
                      icon: Icons.mic_rounded,
                      color: AppColors.primary,
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        RecitationsPage.routeName,
                      ),
                    ),
                    _buildIconItem(
                      context,
                      title: translate('Conversations'),
                      icon: Icons.forum_rounded,
                      color: const Color(0xFF5856D6),
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        Routes.messages,
                      ),
                    ),
                    _buildIconItem(
                      context,
                      title: translate('TeachersRecitation'),
                      icon: Icons.record_voice_over_rounded,
                      color: const Color(0xFF34C759),
                      onTap: () => AuthNavigator.of(context)!.pushConditionally(
                        context,
                        Routes.messageTeacher,
                      ),
                    ),
                    _buildIconItem(
                      context,
                      title: translate('Users'),
                      icon: Icons.group_rounded,
                      color: const Color(0xFF00C7BE),
                      onTap: () => Get.to(() => const UsersListing()),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 4. Group 3: Honor Board (لوحة الشرف)
                _buildGroupCard(
                  context,
                  title: 'الإنجاز والتميز',
                  isDark: isDark,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => const StudentsPage()),
                        borderRadius: AppRadius.radiusMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 36),
                              const SizedBox(width: 8),
                              Text(
                                translate('HonorBoard'),
                                style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 5. Footer Row (كيف يعمل التطبيق - التواصل والدعم - عن التطبيق)
                _buildFooterRow(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Card
  Widget _buildHeaderCard(BuildContext context, bool isDark) {
    final user = SplashCubit.user;
    final isLogin = SplashCubit.isLogin;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      child: Column(
        children: [
          Row(
            children: [
              // User Avatar
              GestureDetector(
                onTap: () {
                  if (isLogin) {
                    Get.to(() => const ProfileBNBPage());
                  }
                },
                child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                  listener: (context, state) {
                    if (state is UpdateProfileSuccess) {
                      SplashCubit.user = state.user;
                    }
                  },
                  builder: (context, state) {
                    return UserAvatarWidget(
                      user: user,
                      radius: 26,
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLogin ? (user?.fullname ?? user?.username ?? translate('User')) : translate('Guest User'),
                      style: AppTypography.bodyLarge(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isLogin ? (user?.email ?? '') : translate('Welcome to Otloha Sah'),
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ).copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Settings Icon Button
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 34,
                ),
                onPressed: () => Get.to(() => const SettingsPage()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xs),

          // User Stats Badges (مستوى التجويد - الرواية - عدد القراءات)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBadge(
                context,
                icon: Icons.school_outlined,
                label: translate('level'),
                value: (user?.level != null && user!.level!.isNotEmpty) ? translate(user!.level!) : 'المستوى الأول',
                isDark: isDark,
              ),
              Container(height: 20, width: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
              _buildStatBadge(
                context,
                icon: Icons.menu_book_outlined,
                label: translate('Narration'),
                value: (user?.recitationMethod != null && user!.recitationMethod!.isNotEmpty) ? translate(user!.recitationMethod!) : 'حفص عن عاصم',
                isDark: isDark,
              ),
              Container(height: 20, width: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
              _buildStatBadge(
                context,
                icon: Icons.mic_none_rounded,
                label: translate('Recitations'),
                value: '${user?.rate?.toInt() ?? 0} تلاوة',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 3),
            Text(
              label,
              style: AppTypography.caption(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ).copyWith(fontSize: 10),
            ),
          ],
        ),
        Text(
          value,
          style: AppTypography.bodySmall(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ).copyWith(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ],
    );
  }

  // Generic Group Card Container
  Widget _buildGroupCard(
    BuildContext context, {
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xs + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Text(
              title,
              style: AppTypography.bodySmall(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ],
      ),
    );
  }

  // Individual Tile Widget inside Grid/Row
  Widget _buildIconItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Icon(icon, color: color, size: 44),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Footer Row (كيف يعمل التطبيق - التواصل والدعم - عن التطبيق)
  Widget _buildFooterRow(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFooterLink(
            context,
            title: translate('HowItWorks'),
            icon: Icons.help_outline_rounded,
            onTap: () => Get.to(() => const HowItWorksPage()),
            isDark: isDark,
          ),
          Container(height: 16, width: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          _buildFooterLink(
            context,
            title: translate('ContactUs'),
            icon: Icons.support_agent_rounded,
            onTap: () => Get.to(() => const ContactUsPage()),
            isDark: isDark,
          ),
          Container(height: 16, width: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          _buildFooterLink(
            context,
            title: translate('AboutApp'),
            icon: Icons.info_outline_rounded,
            onTap: () => Get.to(() => const AboutUsPage()),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTypography.caption(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ).copyWith(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
