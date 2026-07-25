import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/data_source/data_source.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../widget/page_layout.dart';
import 'create_new_password.dart';

class CheckOTPPage extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: PageAuthLayout(pageComponents: bodyView()),
    );
  }

  SafeArea bodyView() {
    return SafeArea(
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/BG.svg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Column(
                      children: [
                        Text(
                          translate('Phone Verfication'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Center(
                          // padding: const EdgeInsets.symmetric(
                          //   horizontal: 50,
                          //   vertical: 20,
                          // ),
                          child: Text(
                            translate('Check your messages'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is VerifyPhoneSuccessState) {
                    Get.offAll(() => const HomePage());
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          translate(
                              'Please enter 6 digits code sent to your number'),
                          style: TextStyle(
                              color: AppColor.txtColor3, fontSize: 18),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.all(16.0),
                          child: Pinput(
                            length: 6,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            onSubmitted: (String pin) =>
                                _showSnackBar(pin, context),
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                          ),
                        ),
                        // const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                onPressed: seconds < 30 && seconds > 0
                                    ? null
                                    : () {
                                        AuthCubit.get(context)
                                            .resendPhoneCode();
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
                                      ? 'Resend in ${seconds.toString()}'
                                      : translate('Resend Code'),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.read),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: state is VerifyPhoneStateLoading
                              ? const LoadingWidget()
                              : ElevatedButton(
                                  onPressed: () {
                                    String? pin = _pinPutController.text;
                                    if (pin.isNotEmpty && pin.length == 6) {
                                      AuthCubit.get(context).verifyPhone(pin);
                                    }
                                  },
                                  child: Text(translate('Verify'))),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final SnackBar snackBar = SnackBar(
      backgroundColor: AppColor.selectColor1,
      duration: const Duration(seconds: 3),
      content: SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'Pin Submitted. Value: $pin',
            style: AppStyle()
                .textStyle1
                .copyWith(fontSize: 16.0, color: AppColor.txtColor3),
          ),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(CreateNewPassword());
    });
  }
}
