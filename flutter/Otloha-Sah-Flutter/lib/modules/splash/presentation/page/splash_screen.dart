import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/check_otp_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/social_login_compelete_form.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../auth_module/presentation/pages/onboard_page.dart';
import '../../../home/presentation/pages/home/block_page.dart';
import '../../../home/presentation/pages/home/home_page.dart';
import '../../business_logic/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = SplashCubit.get(context);
    Future.microtask(() {
      cubit?.getInitDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(builder: (ctx, state) {
        return _bodyView(context, state);
      }, listener: (ctx, state) {
        if (state is SplashFinish) {
          if (state.isBlocked) {
            Navigator.of(context).pushReplacementNamed(BlockedPage.route);
          } else if (SplashCubit.user != null && !state.isProfileCompelete) {
            AuthCubit.get(context).userProfile = SplashCubit.user!;
            Get.offAll(() => const SocialLoginCompeleteFormPage());
          } else if (!state.isPhoneVerified && Constants.hasOTP) {
            Get.offAll(() => CheckOTPPage());
          } else {
            Navigator.of(context).pushReplacementNamed(
              (SplashCubit.isLogin)
                  ? HomePage.routeName
                  : OnBoardPage.routeName,
            );
          }
        }
      }),
    );
  }

  _bodyView(BuildContext context, SplashState state) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.lightBlue, AppColor.fantaBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .25,
            child: Stack(
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.05,
                // ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      'assets/svg/khairakom_logo.svg',
                      color: AppColor.white,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/icons/V.3.png',
                      color: AppColor.white,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Image.asset(
                //       AppIcons.appIcon4,
                //       width: 100,
                //       height: 200,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(
                    'assets/svg/back1.svg',
                    fit: BoxFit.cover,
                    color: Colors.white10,
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: 'MainPage',
                    child: Image.asset(
                      'assets/icons/LOGO_500.gif',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                translate(cubit!.titleProgress),
                style:
                    const TextStyle(fontSize: 20, color: AppColor.lightYellow),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'بدعم و رعاية اوقاف الشيخ\n',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.white,
                                fontFamily: 'Cairo'),
                          ),
                          TextSpan(
                            text: 'محمد بن عبدالعزيز الراجحي',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.white,
                                fontFamily: 'Cairo'),
                          ),
                        ])),
                    // Center(
                    //     child: Text(
                    //         'بدعم ورعايه اوقاف الشيخ\nمحمد بن عبدالعزيز الراجحي')),
                    Image.asset(
                      AppIcons.appIcon1,
                      width: MediaQuery.of(context).size.width * .30,
                    ),
                  ],
                ),
                const SizedBox(height: 32)
              ],
            ),
          )
        ],
      ),
    );
  }
}
