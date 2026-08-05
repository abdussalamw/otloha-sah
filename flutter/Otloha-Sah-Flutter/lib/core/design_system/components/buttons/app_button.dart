import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve Colors based on Variant
    Color backgroundColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.surfaceDark : AppColors.primaryLight;
        textColor = isDark ? AppColors.primaryLight : AppColors.primary;
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = isDark ? AppColors.textPrimaryDark : AppColors.primary;
        borderSide = BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = isDark ? AppColors.textPrimaryDark : AppColors.primary;
        break;
    }

    // Resolve Size Padding & Heights
    double height;
    EdgeInsets padding;
    double fontSize;

    switch (size) {
      case AppButtonSize.small:
        height = 36.0;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm);
        fontSize = 13.0;
        break;
      case AppButtonSize.medium:
        height = 48.0;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        fontSize = 15.0;
        break;
      case AppButtonSize.large:
        height = 56.0;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        fontSize = 17.0;
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: AppTypography.button(color: textColor).copyWith(fontSize: fontSize),
        ),
      ],
    );

    final buttonWidget = Material(
      color: onPressed == null ? backgroundColor.withOpacity(0.5) : backgroundColor,
      borderRadius: AppRadius.radiusMd,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: AppRadius.radiusMd,
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusMd,
            border: borderSide != BorderSide.none ? Border(
              top: borderSide, bottom: borderSide, left: borderSide, right: borderSide,
            ) : null,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: buttonWidget) : buttonWidget;
  }
}
