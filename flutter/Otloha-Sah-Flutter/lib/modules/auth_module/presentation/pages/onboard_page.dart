import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/modules/splash/business_logic/cubit/splash_cubit.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/res/images_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic/auth_cubit.dart';
import 'login_page.dart';
import 'sign_up.dart';
import '../widget/auth_button.dart';
import '../../../home/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class OnBoardPage extends StatefulWidget {
  static const routeName = '/onBoard';

  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  late Timer _timer;
  Map<String, dynamic>? movements = {
    'down': false,
    'up_right': false,
    'count': 0,
  };
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      resetMovments();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resetMovments() {
    movements = {
      'down_right': false,
      'up_right': false,
      'count': 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
          children: [
            _layoutBackgroundImage(AppImages.onbordBack, context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.6),
                  Center(
                    child: ButtonApp(
                      buttonText: tr('login'),
                      width: MediaQuery.of(context).size.width * 0.5,
                      onPressed: () {
                        Get.to(() => const LoginPage());
                      },
                      colors: const [
                        AppColor.btn1Color,
                        AppColor.btn1Color,
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonApp(
                    buttonText: tr('signup'),
                    width: MediaQuery.of(context).size.width * 0.5,
                    onPressed: () {
                      Get.to(() => const SignUpPage());
                    },
                    colors: const [
                      AppColor.btn2Color,
                      AppColor.btn2lColor,
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          var cubit = AuthCubit.get(context);
                          return ButtonApp(
                            buttonText: tr('guest'),
                            width: MediaQuery.of(context).size.width * 0.5,
                            onPressed: () {
                              cubit.changeIsLogin(islog: false).then((value) {
                                Get.offAll(() => const HomePage());
                              });
                            },
                            colors: const [
                              AppColor.btn3Color,
                              AppColor.btn3lColor,
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${DateFormat.y(EasyLocalization.of(context)?.currentLocale?.languageCode).format(DateTime.now())} © ${tr('copyrights')}',
                      style: const TextStyle(
                        color: AppColor.txtGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _layoutBackgroundImage(String image, BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColor.white,
          child: Image.asset(
            image,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onPanUpdate: ((details) {
              if (details.delta.dx > 0 &&
                  details.delta.dy > 0 &&
                  !movements!['up_right'] &&
                  movements!['count'] == 7) {
                movements!['down_right'] = true;
              }

              if (details.delta.dx > 0 &&
                  details.delta.dy < 0 &&
                  movements!['down_right'] &&
                  movements!['count'] == 7) {
                resetMovments();
                Constants.isTesting = !Constants.isTesting;
                if (Constants.isTesting) {
                  Fluttertoast.showToast(msg: 'test mode activated');
                } else {
                  Fluttertoast.showToast(msg: 'test mode deactivated');
                }
              }
            }),
            onTap: (() {
              movements!['count']++;
            }),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              child: Center(
                child: Hero(
                  tag: 'MainPage',
                  child: Image.asset(
                    AppIcons.flatLogoIcon,
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
