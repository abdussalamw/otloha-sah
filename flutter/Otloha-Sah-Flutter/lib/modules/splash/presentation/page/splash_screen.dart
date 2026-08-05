import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../auth_module/business_logic/auth_cubit.dart';
import '../../../auth_module/presentation/pages/check_otp_page.dart';
import '../../../auth_module/presentation/pages/onboard_page.dart';
import '../../../auth_module/presentation/pages/social_login_compelete_form.dart';
import '../../../home/presentation/pages/home/block_page.dart';
import '../../../home/presentation/pages/home/home_page.dart';
import '../../business_logic/cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = SplashCubit.get(context);
    Future.microtask(() {
      cubit?.getInitDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: BlocConsumer<SplashCubit, SplashState>(
        builder: (ctx, state) => _bodyView(context, state),
        listener: (ctx, state) {
          if (state is SplashFinish) {
            if (state.isBlocked) {
              Navigator.of(context).pushReplacementNamed(BlockedPage.route);
            } else if (SplashCubit.user != null && !state.isProfileCompelete) {
              AuthCubit.get(context).userProfile = SplashCubit.user!;
              Get.offAll(() => const SocialLoginCompeleteFormPage());
            } else if (!state.isPhoneVerified && Constants.hasOTP) {
              Get.offAll(() => CheckOTPPage());
            } else {
              Navigator.of(context).pushReplacementNamed(
                HomePage.routeName,
              );
            }
          }
        },
      ),
    );
  }

  Widget _bodyView(BuildContext context, SplashState state) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Header: Both Partner Logos Side-by-Side (خيركم + أوقاف الراجحي)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Right Side: Khairakom Logo
                    SvgPicture.asset(
                      'assets/svg/khairakom_logo.svg',
                      color: Colors.white.withOpacity(0.95),
                      width: size.width * 0.26,
                      height: 48,
                    ),

                    // Left Side: Awqaf Al-Rajhi Logo & Text Badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'بدعم ورعاية أوقاف الشيخ\n',
                                style: AppTypography.bodySmall(color: Colors.white70).copyWith(
                                  fontSize: 10,
                                  height: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: 'محمد بن عبدالعزيز الراجحي',
                                style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Image.asset(
                          AppIcons.appIcon1,
                          width: size.width * 0.22,
                          height: 44,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Center Section: App Main Logo & Progress Status
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'MainPage',
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/LOGO_500.gif',
                      width: size.width * 0.45,
                      height: size.width * 0.45,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state is DownloadingState) ...[
                  SizedBox(
                    width: size.width * 0.6,
                    child: LinearProgressIndicator(
                      value: state.progress > 0 ? state.progress : null,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  translate(cubit?.titleProgress ?? ''),
                  style: AppTypography.bodyMedium(color: AppColors.waveYellow).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Bottom Section: Footer Version Information
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'الإصدار v4 تطوير حلول وبدائل لتقنية المعلومات',
                    style: AppTypography.caption(color: Colors.white60).copyWith(
                      fontSize: 11,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
