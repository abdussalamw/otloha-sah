import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/password_form_field.dart';
import '../../../home/presentation/pages/home/home_page.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../core/utils/themes/color.dart';
import '../widget/auth_button.dart';
import '../widget/page_head_text.dart';
import '../widget/page_layout.dart';

class CreateNewPassword extends StatelessWidget {
  CreateNewPassword({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: PageAuthLayout(pageComponents: bodyView(context)),
    );
  }

  bodyView(BuildContext context) {
    return Center(child: components(context));
  }

  Widget components(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .15),
            pageLayOutTextHead(
              tr('CreateNewPassword'),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 16.0),
            //   child: TextView(
            //     text: tr('ForgotPasswordMsg'),
            //     sizeText: 16,
            //     textAlign: TextAlign.start,
            //     colorText: AppColor.txtColor3,
            //   ),
            // ),
            // const SizedBox(height: 24),
            loginForm(context),
            SizedBox(height: MediaQuery.of(context).size.height * .4),
          ],
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PasswordFormField(
              controller: newPasswordController,
              title: tr('New Password'),
              validator: [
                FormBuilderValidators.required(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PasswordFormField(
              controller: confirmPasswordController,
              title: tr('Confirm Password'),
              validator: [
                FormBuilderValidators.required(),
              ],
            ),
          ),
          const SizedBox(height: 48),
          ButtonApp(
            buttonText: tr('Save'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                debugPrint('validate');
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              }
            },
            width: double.infinity,
            colors: const [
              AppColor.darkBlue,
              AppColor.lightBlue,
            ],
          )
        ],
      ),
    );
  }
}
