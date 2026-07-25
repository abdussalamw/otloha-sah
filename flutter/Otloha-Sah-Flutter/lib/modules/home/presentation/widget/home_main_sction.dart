import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/res/svg_app.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';

import 'progressindicator.dart';

class HomeMainSection extends StatelessWidget {
  const HomeMainSection({
    Key? key,
    required this.title,
    required this.isLogin,
    required this.image,
    required this.gradient1,
    required this.gradient2,
    required this.userProgressIndicator,
    required this.iconColor,
    this.action,
  }) : super(key: key);

  final String title;
  final bool isLogin;
  final String image;
  final Color gradient1;
  final Color gradient2;
  final Color iconColor;

  final UserProgressIndicator userProgressIndicator;

  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: action,
        child: Container(
          height: MediaQuery.of(context).size.height * .23,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: ThemeCubit.isDark
                ? LinearGradient(
                    colors: [AppColor.gradient4, AppColor.gradient4],
                  )
                : LinearGradient(
                    colors: const [Color(0xff08226C), Color(0xff0FBAF3)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/home_card_background.png'),
              fit: BoxFit.cover,
              opacity: 0.13,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Transform(
                  alignment: Alignment.center,
                  transform: Constants.isEn
                      ? Matrix4.rotationY(0)
                      : Matrix4.rotationY(pi),
                  child: SvgPicture.asset(
                    AppSVG.goPage,
                    color: AppColor.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(image),
                    height: 60,
                    width: 60,
                  ),
                  // SvgPicture.asset(
                  //   'assets/svg/Quran.svg',
                  //   width: MediaQuery.of(context).size.width * .125,
                  //   height: MediaQuery.of(context).size.width * .125,
                  //   color: AppColor.white,
                  //   // allowDrawingOutsideViewBox: true,
                  // ),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.center,
                child: TextView(
                  text: title,
                  colorText: AppColor.white,
                  sizeText: 16,
                  weightText: FontWeight.w700,
                  padding: const EdgeInsets.all(0),
                  // textAlign: TextAlign.end,
                ),
              ),
              // isLogin ? userProgressIndicator : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
