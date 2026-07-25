import 'package:flutter/material.dart';
import '../../../modules/settings/business_logic/themes/theme_cubit.dart';

class AppColor {
  static const Color btn1Color = Color(0xfffede65);
  static const Color btn2Color = Color(0xff3682d8);
  static const Color btn2lColor = Color(0xff02d0fe);
  static const Color btn3Color = Color(0xffc2d9f3);
  static const Color btn3lColor = Color(0xffb3f0fe);

  static const Color backOnBoardColor = Color(0xff00b1ec);
  static const Color backButtonColor = Color(0xff2ec3f5);
  static const Color background1Color = Color(0xff24BDEF);

  static const Color borderColor = Color(0xff6ee3fe);
  static const Color borderIconColor = Color(0xff7c7a7a);
  static const Color borderHoverColor = Color(0xfffde174);

  static const Color defaultColor = Color(0xfffbedee);
  static const Color primaryColor = Color(0xff0d758e);
  static const Color accentColor = Color(0x0ffab01c);
  static const Color deepAccentColor = Color(0xfffab01c);
  static const Color secondaryColor = Color(0x0f1597bb);
  static const Color deepsecondaryColor = Color(0xff1597bb);
  static const Color transparent = Colors.transparent;

  ////Text Color
  static const Color lightBlue = Color(0xff01cffd);
  static const Color darkBlue = Color(0xff397cd6);
  static const Color fantaBlue = Color(0xff08226c);
  static const Color txtGrayColor = Color(0xff878585);
  static const Color darkSilver = Color(0xff959394);
  static const Color lightYellow = Color(0xfffede65);
  static const Color hidenBlue = Color(0xff00D2FF);
  static Color headTextColor =
      ThemeCubit.isDark ? const Color(0xFF00D2FF) : const Color(0xff08226c);

  static const Color grey = Colors.grey;
  static const Color black87 = Colors.black87;
  static Color txtColor1 = ThemeCubit.isDark ? Colors.white : Colors.black;
  static const Color white = Colors.white;
  static Color txtColor3 =
      ThemeCubit.isDark ? const Color(0xff01cffd) : const Color(0xff223c8c);
  static const Color txtColor4 = Color(0xff828282);
  static const Color txtColor5 = Color(0xffFF0000);

  /////container
  static const Color conColor1 = Color(0xff066ab2);
  static Color conColor2 = ThemeCubit.isDark
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color(0xffffffff);
  static const Color conColor3 = Color(0xffd5d5d5);
  static const Color conColor3l = Color(0xffECEDEF);
  static const Color conColor4 = Color(0xffFF0000);
  static const Color conColor4l = Color(0xffFF00bc);
  static const Color conColorO = Color(0xffff6600);
  static const Color conColor5 = Color(0xff066ab2);

  /////
  static const Color btnColor1 = Color(0xff2147BD);
  static const Color btnColor2 = Color(0xffffffff);
  static const Color btnColor3 = Color(0xffd5d5d5);
  static const Color btnColor4 = Color(0xED13AE0C);

  ///
  static const Color lineColor = Color.fromARGB(255, 118, 117, 117);

  //

  static const Color background1 = Color(0xffffffff);
  static Color background = ThemeCubit.isDark
      ? const Color.fromARGB(255, 40, 40, 40)
      : const Color.fromARGB(255, 255, 255, 255);

  ///

  static const Color spinner = Color(0xffBFBFBF);

  /////
  static const Color loginColor1 = Color(0xffB1E5FF);
  static const Color loginColor2 = Color(0xff43B0E6);
  static const Color startColor = Color(0xBAB7E7FF);

  /////
  static const Color statusBarColor = Colors.transparent;
  static const Color appBarColor = Color(0xDA43B0E6);
  static const Color bottomBar = Color(0xff066ab2);

  /////
  static const Color boxColor = Color(0xff0094FF);

  ///// extra
  static Color read =
      ThemeCubit.isDark ? const Color(0xFF00D2FF) : const Color(0xff290280);
  static const Color colorRouteLine = Color(0xffFF4081);

  ///gradient
  static const Color gradient1 = Color(0xffB1F2FF);
  static const Color gradient2 = Color(0xFF00D2FF);
  static const Color gradient3 = Color(0xFF3A7BD5);
  static Color gradient4 = ThemeCubit.isDark
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color(0xFFe9fbff);

  static const Color toolBar1 = Color(0xFF00D2FF);
  static const Color toolBar2 = Color(0xFF3A7BD5);

  ///
  static Color backItem = ThemeCubit.isDark
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color(0xFFDBF8FD);
  static Color backItem2 = ThemeCubit.isDark
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color(0xFFBEF1FC);

  static const Color backdone = Color.fromARGB(167, 0, 0, 0);

  ///
  static const Color waveColor = Color.fromARGB(168, 249, 211, 62);
  static const Color waveColor2 = Color(0xffFDD023);

  ///
  static Color selectColor1 = ThemeCubit.isDark
      ? const Color.fromARGB(146, 53, 53, 53)
      : const Color(0x93E2F1F5);
  static const Color selectColor2 = Color(0xFFF5F7F8);

  /// Text Color
  static const Color txtColor2 = Colors.white;
  static const Color txtColor4d = Color(0xFF4B4A4A);

  /// icons
  static const Color iconColor = Color.fromARGB(255, 117, 117, 118);
  static Color iconColor2 =
      ThemeCubit.isDark ? const Color(0xFF00D2FF) : const Color(0xFF142f75);
  static const Color iconColor3 = Color(0xFFf6d955);
  static const Color iconColor4 = Color(0xFFbabdbe);
  static const Color iconColor5 = Color(0xFF03d2ff);
  static const Color iconColor6 = Color.fromARGB(255, 1, 118, 191);

  /// proogess
  static const Color proogessColor1 = Color(0xD5FFD76B);
  static const Color proogTxtColor1 = Color.fromARGB(255, 253, 214, 57);
  static const Color proogessColor2 = Color(0xFFFFFEFE);

  /// container

  static const Color bottomHome = Color(0xED03d2ff);
  static const Color bottomSaved = Color(0xED03d2ff);
  static const Color bottomMenu = Color(0xED03d2ff);

  ///

  static const Color bottom2Bar = Color(0xFF01D0FF);

  static const Color messageColorB = Color(0xffB1F2FF);
  static const Color messageColor = Color(0xFFD4F8FF);
  static const Color messageColor2 = Color(0xFFF8F8F8);
  static const Color messageColor2b = Color(0xFFE8E8E8);
  static Color userNameColor =
      ThemeCubit.isDark ? Colors.white : const Color(0xFF7A7878);

  /// wanings
  static const Color warningColor = Color(0xFFfdfae9);
  static const Color warningIconColor = Color(0xFFf6d642);
  static const Color warningAlertColor = Color(0xFFf5c716);

  static const Color lightGrey = Color(0xFFedf1f7);
  static const Color txtGrey = Color(0xFF9da8bd);
}
