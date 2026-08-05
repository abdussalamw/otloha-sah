import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';

Widget pageLayOutTextHead(String title, [BuildContext? context]) {
  final isDark = context != null ? Theme.of(context).brightness == Brightness.dark : false;

  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 24),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: AppTypography.h1Large(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ).copyWith(fontWeight: FontWeight.bold, fontSize: 24),
    ),
  );
}
