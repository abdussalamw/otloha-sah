import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/core/utils/res/icons_app.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/login_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/sign_up.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';

class OnBoardPage extends StatefulWidget {
  static const routeName = '/onBoard';

  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  late Timer _timer;
  Map<String, dynamic>? movements = {
    'down': false,
    'up_right': false,
    'count': 0,
  };

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      resetMovments();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resetMovments() {
    movements = {
      'down_right': false,
      'up_right': false,
      'count': 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Secret gesture logo section
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onPanUpdate: ((details) {
                    if (details.delta.dx > 0 &&
                        details.delta.dy > 0 &&
                        !movements!['up_right'] &&
                        movements!['count'] == 7) {
                      movements!['down_right'] = true;
                    }

                    if (details.delta.dx > 0 &&
                        details.delta.dy < 0 &&
                        movements!['down_right'] &&
                        movements!['count'] == 7) {
                      resetMovments();
                      Constants.isTesting = !Constants.isTesting;
                      if (Constants.isTesting) {
                        Fluttertoast.showToast(msg: 'test mode activated');
                      } else {
                        Fluttertoast.showToast(msg: 'test mode deactivated');
                      }
                    }
                  }),
                  onTap: (() {
                    movements!['count']++;
                  }),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'MainPage',
                          child: Image.asset(
                            AppIcons.flatLogoIcon,
                            width: 150,
                            height: 150,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.menu_book_rounded,
                              size: 100,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'اتلوها صح',
                          style: AppTypography.h1Large(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ).copyWith(fontWeight: FontWeight.bold, fontSize: 32),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'تطبيق تصحيح التلاوة وتعلّم القرآن الكريم',
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

              // Action buttons section
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.radiusMd,
                          ),
                        ),
                        onPressed: () => Get.to(() => const LoginPage()),
                        child: Text(
                          tr('login'),
                          style: AppTypography.buttonStyle(color: Colors.white).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.radiusMd,
                          ),
                        ),
                        onPressed: () => Get.to(() => const SignUpPage()),
                        child: Text(
                          tr('signup'),
                          style: AppTypography.buttonStyle(color: AppColors.primary).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Guest / Continue Without Login Button
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        var cubit = AuthCubit.get(context);
                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.radiusMd,
                              ),
                            ),
                            onPressed: () {
                              cubit.changeIsLogin(islog: false).then((value) {
                                Get.offAll(() => const HomePage());
                              });
                            },
                            child: Text(
                              tr('guest'),
                              style: AppTypography.bodyMedium(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Copyright Footer
                    Text(
                      '${DateFormat.y(EasyLocalization.of(context)?.currentLocale?.languageCode).format(DateTime.now())} © ${tr('copyrights')}',
                      style: AppTypography.caption(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
}
