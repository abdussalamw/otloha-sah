import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/data_source.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:pinput/pinput.dart';

class CheckOTPPage extends StatefulWidget {
  const CheckOTPPage({super.key});

  @override
  CheckOTPPageState createState() => CheckOTPPageState();
}

class CheckOTPPageState extends State<CheckOTPPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  Timer? _timer;
  int seconds = 30;

  @override
  void initState() {
    AppDataSource().resendOTP();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: AppTypography.h2Bold(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: translate('التحقق من الهاتف'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is VerifyPhoneSuccessState) {
                              Get.offAll(() => const HomePage());
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mark_email_read_rounded,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  translate('أدخل رمز التحقق'),
                                  style: AppTypography.h2Bold(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  translate('الرجاء إدخال الرمز المكون من 6 أرقام المرسل إلى جوالك'),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodySmall(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                Pinput(
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinPutController,
                                  onSubmitted: (String pin) {
                                    if (pin.length == 6) {
                                      AuthCubit.get(context).verifyPhone(pin);
                                    }
                                  },
                                ),

                                const SizedBox(height: AppSpacing.lg),

                                TextButton(
                                  onPressed: seconds < 30 && seconds > 0
                                      ? null
                                      : () {
                                          AuthCubit.get(context).resendPhoneCode();
                                          seconds = 30;
                                          _timer = Timer.periodic(
                                            const Duration(seconds: 1),
                                            (timer) {
                                              setState(() {
                                                seconds--;
                                                if (seconds == 0) {
                                                  _timer!.cancel();
                                                }
                                              });
                                            },
                                          );
                                        },
                                  child: Text(
                                    seconds < 30 && seconds > 0
                                        ? 'إعادة الإرسال بعد ${seconds.toString()} ثانية'
                                        : translate('إعادة إرسال الرمز'),
                                    style: AppTypography.bodyMedium(
                                      color: seconds < 30 && seconds > 0 ? AppColors.textMutedLight : AppColors.primary,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.md),

                                state is VerifyPhoneStateLoading
                                    ? const LoadingWidget()
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: AppRadius.radiusMd,
                                            ),
                                          ),
                                          onPressed: () {
                                            String pin = _pinPutController.text;
                                            if (pin.isNotEmpty && pin.length == 6) {
                                              AuthCubit.get(context).verifyPhone(pin);
                                            }
                                          },
                                          child: Text(
                                            translate('تأكيد التحقق'),
                                            style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
