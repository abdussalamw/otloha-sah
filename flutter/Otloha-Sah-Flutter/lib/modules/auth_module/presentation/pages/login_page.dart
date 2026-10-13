import 'dart:io';

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
import 'package:otloha_sah_flutter/core/utils/res/icons_app.dart';
import 'package:otloha_sah_flutter/core/widgets/password_form_field.dart';
import 'package:otloha_sah_flutter/core/widgets/text_from_fielid.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/core/widgets/vali_errorr_text.dart';
import 'package:otloha_sah_flutter/data_source/remote/auth_services.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/forget_password_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/sign_up.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_layout.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    AuthCubit.get(context).setInitail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageAuthLayout(
      pageComponents: loginComponents(context),
    );
  }

  Widget loginComponents(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogInSuccessState) {
          Get.offAll(() => const HomePage());
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Column(
          children: [
            ToolBarApp(
              backIcon: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleWidget: Text(
                tr('Login'),
                style: AppTypography.h3Bold(color: Colors.white).copyWith(fontSize: 18),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    // Stitch Brand Header
                    Image.asset(
                      AppIcons.flatLogoIcon,
                      width: 80,
                      height: 80,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.menu_book_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'أتلوها صح',
                      style: AppTypography.h1Large(color: Colors.white).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مرحباً بك مجدداً في رحلتك القرآنية',
                      style: AppTypography.bodyMedium(color: Colors.white70).copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Stitch Login Form Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: loginForm(cubit, isDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getErrorMessage(dynamic err) {
    if (err == null) return '';
    if (err is String) return err;
    if (err is List && err.isNotEmpty) return err.first.toString();
    if (err is Map && err.isNotEmpty) {
      final firstVal = err.values.first;
      if (firstVal is List && firstVal.isNotEmpty) return firstVal.first.toString();
      return firstVal.toString();
    }
    return err.toString();
  }

  Widget loginForm(AuthCubit cubit, bool isDark) {
    return Form(
      key: formKey,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email / Phone Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldApp(
                    title: tr('emailOrPhone'),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  if (state is LogInErrorState && state.error['identifier'] != null)
                    ValidationErrorText(
                      error: _getErrorMessage(state.error['identifier']),
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Password Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PasswordFormField(
                    title: tr('password'),
                    controller: passwordController,
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  if (state is LogInErrorState && state.error['password'] != null)
                    ValidationErrorText(
                      error: _getErrorMessage(state.error['password']),
                    ),
                ],
              ),

              if (state is LogInErrorState) ...[
                if (state.error['non_field_errors'] != null)
                  ValidationErrorText(
                    error: _getErrorMessage(state.error['non_field_errors']),
                  )
                else if (state.error['detail'] != null)
                  ValidationErrorText(
                    error: _getErrorMessage(state.error['detail']),
                  )
                else if (state.error['__all__'] != null)
                  ValidationErrorText(
                    error: _getErrorMessage(state.error['__all__']),
                  ),
              ],

              // Forgot Password link
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Get.to(const ForgotPasswordPage()),
                  child: Text(
                    tr('ForgotPassword'),
                    style: AppTypography.bodyMedium(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Login Button
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return (state is LogInLoadingState || state is LogInSuccessState)
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )
                      : BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.radiusMd,
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (formKey.currentState!.validate()) {
                                    await cubit.userLogIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child: Text(
                                  tr('Login'),
                                  style: AppTypography.buttonStyle(color: Colors.white).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Register Now Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('Registernow?'),
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Get.to(const SignUpPage()),
                    child: Text(
                      tr('RegisterNow'),
                      style: AppTypography.bodyMedium(
                        color: AppColors.primary,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // Social Login Section
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      'أو من خلال',
                      style: AppTypography.caption(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Google Sign In
              SocialLoginButton(
                buttonType: SocialLoginButtonType.google,
                text: 'تسجيل الدخول عبر Google',
                borderRadius: 12,
                onPressed: () {
                  cubit.loginWith(Providers.google);
                },
              ),

              // Apple Sign In (iOS and Supported platforms)
              if (Platform.isIOS || Platform.isMacOS) ...[
                const SizedBox(height: AppSpacing.sm),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.apple,
                  text: 'تسجيل الدخول عبر Apple',
                  borderRadius: 12,
                  onPressed: () {
                    cubit.loginWith(Providers.apple);
                  },
                ),
              ],

              // Facebook Sign In
              const SizedBox(height: AppSpacing.sm),
              SocialLoginButton(
                buttonType: SocialLoginButtonType.facebook,
                text: 'تسجيل الدخول عبر Facebook',
                borderRadius: 12,
                onPressed: () {
                  cubit.loginWith(Providers.facebook);
                },
              ),
            ],
          );
        },
      ),
    );

  }
}
