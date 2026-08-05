import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/design_system/components/cards/app_card.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';

class ItemSurah extends StatelessWidget {
  const ItemSurah({
    Key? key,
    required this.name,
    required this.partName,
    required this.pageFrom,
    required this.pageTO,
    required this.verses,
    required this.onLongPress,
    this.action,
    this.isMakkah = true,
    this.isSelect = false,
  }) : super(key: key);

  final String name;
  final String partName;
  final int pageFrom;
  final int pageTO;
  final int verses;
  final bool isMakkah;
  final bool isSelect;
  final Function() onLongPress;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: action,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusMd,
          color: isSelect
              ? AppColors.primary.withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Chapter SVG Icon & Surah Name
            Row(
              children: [
                SvgPicture.asset(
                  AppSVG.chapter,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isSelect ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  name,
                  style: AppTypography.h3Medium(
                    color: isSelect
                        ? AppColors.primary
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ).copyWith(
                    fontFamily: 'Hafs20',
                    fontSize: 17,
                  ),
                ),
              ],
            ),

            // Verses & Page Range Info
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${translate('Verses')} $verses',
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ).copyWith(fontSize: 11),
                    ),
                    Text(
                      '${translate('Pages')} $pageFrom - $pageTO',
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ).copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),

                // Origin Icon (Makkah vs Madinah)
                SvgPicture.asset(
                  isMakkah ? AppSVG.makkah : AppSVG.madina,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
