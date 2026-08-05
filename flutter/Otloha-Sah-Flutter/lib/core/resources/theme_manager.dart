import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/tokens/app_colors.dart';
import '../design_system/tokens/app_radius.dart';

/// Central ThemeData builder for Light and Dark themes in Otloha Sah.
ThemeData getApplicationLightTheme() {
  const fontFamily = 'Beiruti';

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    disabledColor: AppColors.textMutedLight,
    canvasColor: AppColors.surfaceLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.accent,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.surfaceLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.primaryDark),
      actionsIconTheme: const IconThemeData(color: AppColors.primaryDark),
      titleTextStyle: TextStyle(
        fontFamily: 'Beiruti',
        color: AppColors.primaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      shadowColor: Colors.black.withOpacity(0.04),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        minimumSize: const Size.fromHeight(48),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        minimumSize: const Size.fromHeight(48),
      ),
    ),
  );
}

ThemeData getApplicationDarkTheme() {
  const fontFamily = 'Beiruti';

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.surfaceDark,
    primaryColorDark: AppColors.primaryDark,
    disabledColor: AppColors.textMutedDark,
    canvasColor: AppColors.surfaceDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.surfaceDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      actionsIconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      titleTextStyle: TextStyle(
        fontFamily: 'Beiruti',
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      shadowColor: Colors.black.withOpacity(0.25),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        minimumSize: const Size.fromHeight(48),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        minimumSize: const Size.fromHeight(48),
      ),
    ),
  );
}
