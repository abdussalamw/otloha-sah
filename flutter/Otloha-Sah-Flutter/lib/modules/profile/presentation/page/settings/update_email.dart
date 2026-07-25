import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/password_form_field.dart';
import '../../../../../core/widgets/vali_errorr_text.dart';
import '../../../../settings/business_logic/settings/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../../core/utils/constant/utils.dart';
import '../../../../../../core/utils/themes/color.dart';
import '../../../../../../core/widgets/text_from_fielid.dart';
import '../../../../auth_module/presentation/widget/auth_button.dart';

class UpdateEmail extends StatelessWidget {
  UpdateEmail({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = SettingsCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(translate('Update Email')),
          ),
          body: SafeArea(
            child: Column(
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              // shrinkWrap: true,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormFieldApp(
                                //  color: AppColor.lightBlue,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                title: tr('NewEmail'),
                                validator: [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error.errors?['new_email'] !=
                                            null)
                                        ? state.error.errors!['new_email'][0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 25),
                            PasswordFormField(
                              controller: passwordController,
                              title: tr('Password'),
                              //   keyboardType: TextInputType.visiblePassword,
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error.errors?['password'] !=
                                            null)
                                        ? state.error.errors!['password'][0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 50),
                            (state is UpdateEmailLoadingState)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonApp(
                                    buttonText: tr('Update'),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.updateEmail(
                                            email: emailController.text,
                                            password: passwordController.text);
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
            ),
          ),
        );
      },
    );
  }
}
