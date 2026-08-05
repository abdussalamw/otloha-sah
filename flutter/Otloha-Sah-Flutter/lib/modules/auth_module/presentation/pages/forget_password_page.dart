import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/widgets/text_from_fielid.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/core/widgets/vali_errorr_text.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  late AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    cubit = AuthCubit.get(context);

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
                title: tr('استعادة كلمة المرور'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Form(
                          key: formKey,
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is ForgotPasswordSuccessState) {
                                showToast(cubit.msg, context);
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
                                      Icons.lock_reset_rounded,
                                      size: 48,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    tr('نسيت كلمة المرور؟'),
                                    style: AppTypography.h2Bold(
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    tr('أدخل بريدك الإلكتروني المسجل لإرسال رابط إعادة تعيين كلمة المرور'),
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodySmall(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  TextFormFieldApp(
                                    title: tr('Email'),
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.email(),
                                    ],
                                  ),
                                  if (state is ForgotPasswordErrorState)
                                    ValidationErrorText(
                                      error: (state.error['email'] != null) ? state.error['email'][0] : '',
                                    ),
                                  const SizedBox(height: AppSpacing.lg),
                                  (state is ForgotPasswordLoadingState)
                                      ? const CircularProgressIndicator()
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
                                            onPressed: () async {
                                              if (formKey.currentState!.validate()) {
                                                var email = emailController.text;
                                                cubit.passwordReset(email: email);
                                              }
                                            },
                                            child: Text(
                                              tr('إرسال رابط الاستعادة'),
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

  void showToast(String msg, BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}
