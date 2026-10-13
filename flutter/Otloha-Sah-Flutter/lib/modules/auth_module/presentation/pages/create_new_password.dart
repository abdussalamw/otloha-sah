import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/widgets/password_form_field.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_layout.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({Key? key}) : super(key: key);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageAuthLayout(
      pageComponents: Column(
        children: [
          ToolBarApp(
            backIcon: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
            titleWidget: Text(
              tr('CreateNewPassword'),
              style: AppTypography.h3Bold(color: Colors.white).copyWith(fontSize: 18),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
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
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            tr('CreateNewPassword'),
                            textAlign: TextAlign.center,
                            style: AppTypography.h2Bold(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            tr('أدخل كلمة المرور الجديدة وتأكيدها للمتابعة'),
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          PasswordFormField(
                            controller: newPasswordController,
                            title: tr('New Password'),
                            validator: [
                              FormBuilderValidators.required(),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PasswordFormField(
                            controller: confirmPasswordController,
                            title: tr('Confirm Password'),
                            validator: [
                              FormBuilderValidators.required(),
                              (val) {
                                if (val != newPasswordController.text) {
                                  return tr('Passwords do not match');
                                }
                                return null;
                              },
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SizedBox(
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
                                  Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                                }
                              },
                              child: Text(
                                tr('Save'),
                                style: AppTypography.buttonStyle(color: Colors.white).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
        ],
      ),
    );
  }
}
