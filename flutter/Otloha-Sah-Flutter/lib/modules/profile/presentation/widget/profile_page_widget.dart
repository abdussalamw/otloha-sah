import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/design_system/components/cards/app_card.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/user_avatar_widget.dart';
import '../../../../core/widgets/warnings_and_alerts/warning.dart';
import '../../../../data_source/models/progress/statistics_model.dart';
import '../../../../data_source/remote/progress_service.dart';
import '../../../auth_module/business_logic/auth_cubit.dart';
import '../../../auth_module/presentation/pages/onboard_page.dart';
import '../../../home/business_logic/cubit/home_cubit.dart';
import '../../../settings/presentation/pages/settings/about_us_page.dart';
import '../../../settings/presentation/pages/settings/contact_us_page.dart';
import '../../../settings/presentation/pages/settings/how_it_works_page.dart';
import '../../../users/presentation/pages/honor_board.dart';
import '../../business_logic/profile_pic_cubit/profile_page_cubit.dart';
import '../page/profile_settings.dart';
import '../../../recitations/presentation/widget/recitation_item.dart';
import '../../../splash/business_logic/cubit/splash_cubit.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import '../../../../core/utils/themes/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          if (SplashCubit.missedNarrationCertification != null && user == null)
            GestureDetector(
              onTap: () {
                HomeCubit.get(context).changeIndex(1);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: AppColor.warningColor,
                    borderRadius: BorderRadius.circular(10)),
                child: WarningMessage(
                    text:
                        '${translate('you did not reach the minimum number of recitations required for Narration')} ${SplashCubit.missedNarrationCertification?.name.translate() ?? ''}'),
              ),
            ),
          ProfileHeader(
            profileImage: user == null
                ? ProfilePageCubit.get(context)
                        .currentUserProfile!
                        .profileImage ??
                    ''
                : user!.profileImage ?? '',
            user: user,
          ),
          ProfileBody(
            user: user ?? ProfilePageCubit.get(context).currentUserProfile!,
          ),
          const SizedBox(height: AppSpacing.md),

          // User Menu Hub Section
          Expanded(
            child: ListView(
              children: [
                _buildUserHubItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'تعديل الملف الشخصي',
                  onTap: () => Get.to(() => ProfileSettings()),
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildUserHubItem(
                  context,
                  icon: Icons.military_tech_rounded,
                  title: 'لوحة الشرف والأوسمة',
                  onTap: () => Get.to(() => const HonorBoardPage(type: 'student')),
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildUserHubItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'كيف يعمل التطبيق',
                  onTap: () => Get.to(() => const HowItWorksPage()),
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildUserHubItem(
                  context,
                  icon: Icons.support_agent_rounded,
                  title: 'التواصل والدعم الفني',
                  onTap: () => Get.to(() => const ContactUsPage()),
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildUserHubItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'عن تطبيق اتلوها صح والأوقاف',
                  onTap: () => Get.to(() => const AboutUsPage()),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (SplashCubit.isLogin)
                  _buildUserHubItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    isDanger: true,
                    onTap: () {
                      AuthCubit.get(context).userLogOut();
                    },
                  )
                else
                  _buildUserHubItem(
                    context,
                    icon: Icons.login_rounded,
                    title: 'تسجيل الدخول',
                    onTap: () {
                      Get.to(() => const OnBoardPage());
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHubItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            decoration: BoxDecoration(
              color: isDanger
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(
              icon,
              color: isDanger ? AppColors.error : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium(
                color: isDanger
                    ? AppColors.error
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profileImage, this.user});
  final String profileImage;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserAvatarWidget(
            user: user,
            imageUrl: profileImage,
            radius: 45,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (user == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ProfileSettings());
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) => AppColor.white),
                              side: MaterialStateProperty.resolveWith<BorderSide>(
                                  (states) => BorderSide(
                                      color: AppColor.headTextColor))),
                          child: Text(
                            translate('edit_profile'),
                            style: const TextStyle(
                                color: AppColor.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (user == null)
                  FutureBuilder<StatisticsModel>(
                    future: ProgressService().getStatistics(
                        QuranCacheRepository.narrationSelectedId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {}
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            statistics(snapshot.data?.acceptedRecitations ?? 0,
                                tr('accepted')),
                            statistics(snapshot.data?.pendingRecitations ?? 0,
                                tr('pending')),
                            statistics(snapshot.data?.rejectedRecitations ?? 0,
                                tr('rejected')),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  statistics(int amount, String title) => Column(
        children: [
          Text(
            amount.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
          Text(
            translate(title),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
        ],
      );
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('ID') + ': ' + user.id!.toString(),
            style: TextStyle(
              color: AppColor.headTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.username,
            style: TextStyle(
              color: AppColor.headTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.person),
              Text(SplashCubit.teacher?.teacherProfile?.fullName ?? ''),
            ],
          ),

          const SizedBox(height: 4),

          if (user.bio != null && user.bio!.isNotEmpty) Text(user.bio ?? ''),
          Row(
            children: [
              const Icon(Icons.attach_file),
              Text(
                user.email,
                style: const TextStyle(color: Colors.blueAccent),
              )
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconedData(Icons.calendar_month, user.birthdate ?? ''),
              iconedData(Icons.equalizer, user.level!),
              iconedData(Icons.phone, user.phone ?? ''),
            ],
          )
        ],
      ),
    );
  }

  iconedData(IconData icon, String text) => Container(
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.txtColor4,
            ),
            Text(
              text,
              style: const TextStyle(color: AppColor.txtColor4),
            ),
          ],
        ),
      );
}
