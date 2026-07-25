import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/password_form_field.dart';
import 'package:otloha_sah_flutter/core/widgets/text_from_fielid.dart';
import 'package:otloha_sah_flutter/core/widgets/text_view.dart';
import 'package:otloha_sah_flutter/core/widgets/vali_errorr_text.dart';
import 'package:otloha_sah_flutter/data_source/remote/auth_services.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/forget_password_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/google_signin.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/sign_up.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/social_login_compelete_form.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/auth_button.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_head_text.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_layout.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
// import 'package:twitter_login/twitter_login.dart';

// ignore: must_be_immutable
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

  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(width: 1, color: AppColor.lightBlue),
  );

  @override
  void initState() {
    AuthCubit.get(context).setInitail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageAuthLayout(
        pageComponents: loginComponents(context),
      ),
    );
  }

  Widget loginComponents(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogInSuccessState) {
          Get.offAll(() => const HomePage());

          // var cubit = AuthCubit.get(context);
          // cubit.changeIsLogin(islog: true).then((value) {
          //   cubit.saveProfile().then((value) {
          //     ProfilePageCubit.get(context).userProfile().then((value) {

          //     });
          //   });
          // });
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  pageLayOutTextHead(tr('Login')),
                  loginForm(cubit),
                  // const SignInDemo(),
                  // SocialLoginButton(
                  //   buttonType: SocialLoginButtonType.facebook,
                  //   onPressed: () async {
                  //     cubit.loginWith(Providers.facebook);
                  //   },
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loginForm(AuthCubit cubit) {
    return Form(
      key: formKey,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  TextFormFieldApp(
                      title: tr('emailOrPhone'),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: [
                        FormBuilderValidators.required(),
                      ]),
                  (state is LogInErrorState)
                      ? ValidationErrorText(
                          error: (state.error['identifier'] != null)
                              ? state.error['identifier'][0]
                              : '')
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  PasswordFormField(
                    title: tr('password'),
                    controller: passwordController,
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  (state is LogInErrorState)
                      ? ValidationErrorText(
                          error: (state.error['password'] != null)
                              ? state.error['password'][0]
                              : '')
                      : const SizedBox(),
                ],
              ),
              (state is LogInErrorState)
                  ? ValidationErrorText(
                      error: (state.error['non_field_errors'] != null)
                          ? state.error['non_field_errors']
                          : (state.error['__all__'] != null)
                              ? state.error['__all__'][0]
                              : '')
                  : const SizedBox(),
              TextView(
                text: tr('ForgotPassword'),
                sizeText: 13,
                action: () {
                  Get.to(const ForgotPasswordPage());
                },
                weightText: FontWeight.w500,
                textAlign: TextAlign.end,
                colorText: AppColor.txtGrayColor,
                padding: const EdgeInsets.all(8),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return (state is LogInLoadingState ||
                          state is LogInSuccessState)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            // var homeCubit = HomeCubit.get(context);
                            return ButtonApp(
                              buttonText: tr('Login'),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                if (formKey.currentState!.validate()) {
                                  debugPrint('validate');

                                  await cubit.userLogIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              width: double.infinity,
                              colors: const [
                                AppColor.btn2Color,
                                AppColor.btn2lColor,
                              ],
                            );
                          },
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextView(
                      text: tr('Registernow?'),
                      sizeText: 14,
                      colorText: AppColor.txtGrayColor,
                    ),
                    TextView(
                      text: tr('RegisterNow'),
                      sizeText: 14,
                      action: () {
                        Get.to(const SignUpPage());
                      },
                      weightText: FontWeight.w600,
                      textAlign: TextAlign.end,
                      colorText: AppColor.txtGrayColor,
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (Platform.isAndroid)
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () {
                    cubit.loginWith(Providers.facebook);
                  },
                ),
              // SocialLoginButton(
              //   buttonType: SocialLoginButtonType.twitter,
              //   onPressed: () async {
              //     final twitterLogin = TwitterLogin(
              //       // Consumer API keys
              //       apiKey: 'Qa9KuNTVUUurcqXYqTrPzDB1l',
              //       // Consumer API Secret keys
              //       apiSecretKey:
              //           'waK2a9YXRyvbxvh4cOgfEQm2VsarABCBo8S39hi6cRicuAayQu',
              //       // Registered Callback URLs in TwitterApp
              //       // Android is a deeplink
              //       // iOS is a URLScheme
              //       redirectURI:
              //           'https://otlohasah.itqadem.com/auth/x/callback',
              //     );
              //     final authResult = twitterLogin.login();
              //     switch ((await authResult).status) {
              //       case TwitterLoginStatus.loggedIn:
              //         // success
              //         break;
              //       case TwitterLoginStatus.cancelledByUser:
              //         // cancel
              //         break;
              //       case TwitterLoginStatus.error:
              //         // error
              //         break;
              //       case null:
              //         // TODO: Handle this case.
              //         break;
              //     }
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
