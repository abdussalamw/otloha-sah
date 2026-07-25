import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/password_form_field.dart';
import '../../../../../core/widgets/tool_bar_app.dart';
import '../../../../../core/widgets/vali_errorr_text.dart';
import '../../../../auth_module/presentation/widget/auth_button.dart';
import '../../../../settings/business_logic/settings/settings_cubit.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [
                topView(context),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PasswordFormField(
                              controller: oldPasswordController,
                              title: tr('Old Password'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error
                                                .errors?['old_password'] !=
                                            null)
                                        ? state.error.errors!['old_password'][0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 24),
                            PasswordFormField(
                              controller: newPasswordController,
                              title: tr('New Password'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error
                                                .errors?['new_password1'] !=
                                            null)
                                        ? state.error.errors!['new_password1']
                                            [0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 24),
                            PasswordFormField(
                              controller: confirmPasswordController,
                              title: tr('Confirm Password'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error
                                                .errors?['new_password2'] !=
                                            null)
                                        ? state.error.errors!['new_password2']
                                            [0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 50),
                            ButtonApp(
                              buttonText: tr('Update'),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SettingsCubit.get(context).changePassword(
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                  );
                                }
                              },
                              width: double.infinity,
                              colors: const [
                                AppColor.darkBlue,
                                AppColor.lightBlue,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget topView(BuildContext context) {
    return ToolBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Change Password'),
    );
  }
}
