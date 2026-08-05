import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_shadows.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide border;
  final bool hasShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.border = BorderSide.none,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBgColor = backgroundColor ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final shadows = hasShadow ? (isDark ? AppShadows.softCardDark : AppShadows.softCardLight) : null;

    final container = Container(
      margin: margin,
      padding: padding ?? AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: defaultBgColor,
        borderRadius: AppRadius.radiusLg,
        boxShadow: shadows,
        border: border != BorderSide.none ? Border(
          top: border, bottom: border, left: border, right: border,
        ) : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: AppRadius.radiusLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radiusLg,
          child: container,
        ),
      );
    }

    return container;
  }
}
