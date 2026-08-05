import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';

/// AppTypography defines cohesive text styles for Otloha Sah using Cairo and Amiri/Quranic fonts.
abstract class AppTypography {
  // Primary Font Family: Beiruti
  static String primaryFontFamily = 'Beiruti';

  // Headlines
  static TextStyle h1Large({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.4,
        color: color ?? AppColors.primaryDark,
      );

  static TextStyle h2Medium({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: color ?? AppColors.primary,
      );

  static TextStyle h2Bold({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.35,
        color: color ?? AppColors.primary,
      );

  static TextStyle h3Small({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color ?? AppColors.primaryDark,
      );

  static TextStyle h3Medium({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color ?? AppColors.primaryDark,
      );

  static TextStyle h3Bold({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: color ?? AppColors.primaryDark,
      );

  // Body Texts
  static TextStyle bodyLarge({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: color ?? AppColors.textPrimaryLight,
      );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.45,
        color: color ?? AppColors.textSecondaryLight,
      );

  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
        color: color ?? AppColors.textMutedLight,
      );

  // Buttons & Labels
  static TextStyle button({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? Colors.white,
      );

  static TextStyle buttonStyle({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? Colors.white,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: 'Beiruti',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textMutedLight,
      );

  // Special Quranic Verses / Surah Header Style (Traditional Arabic typography)
  static TextStyle quranAyah({double fontSize = 22, Color? color}) => GoogleFonts.amiri(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 2.0, // Extra height for diacritics / Tashkeel
        color: color ?? AppColors.primaryDark,
      );
}
