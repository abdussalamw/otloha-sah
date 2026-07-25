import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../../../core/widgets/text_from_fielid.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../core/widgets/vali_errorr_text.dart';
import '../../business_logic/auth_cubit.dart';
import '../widget/auth_button.dart';
import '../widget/page_head_text.dart';
import '../widget/page_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

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
    cubit = AuthCubit.get(context);
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
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            pageLayOutTextHead(
              tr('ForgotPassword'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextView(
                text: tr('ForgotPasswordMsg'),
                sizeText: 16,
                textAlign: TextAlign.start,
                colorText: AppColor.txtColor3,
              ),
            ),
            const SizedBox(height: 24),
            loginForm(context),
            SizedBox(height: MediaQuery.of(context).size.height * .5),
          ],
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccessState) {
          showToast(cubit.msg, context);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  TextFormFieldApp(
                      title: tr('Email'),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                  (state is ForgotPasswordErrorState)
                      ? ValidationErrorText(
                          error: (state.error['email'] != null)
                              ? state.error['email'][0]
                              : '')
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 48),
              (state is ForgotPasswordLoadingState)
                  ? const CircularProgressIndicator()
                  : ButtonApp(
                      buttonText: tr('ForgotPassword'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var email = emailController.text;
                          cubit.passwordReset(email: email);
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
        );
      },
    );
  }

  void showToast(String msg, BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}
