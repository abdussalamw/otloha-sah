import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/text_from_fielid.dart';
import '../../../../../core/widgets/vali_errorr_text.dart';
import '../../../../auth_module/presentation/widget/auth_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../settings/business_logic/settings/settings_cubit.dart';

import '../../../../../../core/utils/constant/utils.dart';

class UpdatePhone extends StatelessWidget {
  UpdatePhone({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Update Phone')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormFieldApp(
                              //  color: AppColor.lightBlue,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              title: tr('New Phone'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error.errors?['new_phone'] !=
                                            null)
                                        ? state.error.errors!['new_phone'][0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 24),
                            TextFormFieldApp(
                                controller: passwordController,
                                title: tr('Password'),
                                keyboardType: TextInputType.visiblePassword,
                                validator: [
                                  FormBuilderValidators.required(),
                                ]),
                            (state is InvalidDataErrorState)
                                ? ValidationErrorText(
                                    error: (state.error.errors?['password'] !=
                                            null)
                                        ? state.error.errors!['password'][0]
                                        : '')
                                : const SizedBox(),
                            const SizedBox(height: 48),
                            ButtonApp(
                              buttonText: tr('Update'),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SettingsCubit.get(context).updatePhone(
                                    phone: phoneController.text,
                                    password: passwordController.text,
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
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
