import 'package:flutter/material.dart';

import '../utils/themes/color.dart';
import 'color_manager.dart';

ThemeData getApplicationLightTheme() {
  ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColorManager.white,
    // main colors of the app
    primaryColor: ColorManager.white,
    primaryColorLight: ColorManager.primaryOpacity70,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    canvasColor: ColorManager.white,
    // ripple color
    splashColor: ColorManager.primaryOpacity70,
    fontFamily: 'Cairo',
    // card view theme
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: 4,
    ),
    // App bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.appBar,
      actionsIconTheme: IconThemeData(color: AppColor.txtColor1),
      iconTheme: IconThemeData(color: AppColor.userNameColor),
      titleTextStyle: TextStyle(
        color: AppColor.txtColor3,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),

    // Button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.primaryOpacity70,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size.fromHeight(50),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: ColorManager.grey)
        .copyWith(background: ColorManager.white),
  );
  return light;

  /// return ThemeData.light();
}

ThemeData getApplicationDarkTheme() {
  return ThemeData.dark();
}
