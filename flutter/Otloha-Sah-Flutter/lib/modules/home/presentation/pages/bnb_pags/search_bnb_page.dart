import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class SearchBNBPage extends StatefulWidget {
  const SearchBNBPage({Key? key}) : super(key: key);

  @override
  State<SearchBNBPage> createState() => _SearchBNBPageState();
}

class _SearchBNBPageState extends State<SearchBNBPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Modern Header with Back Button
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: 'البحث في النص القرآني',
              ),

              // Search Content in Modern Container Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: ClipRRect(
                      borderRadius: AppRadius.radiusMd,
                      child: SearchQuran(
                        onTapVerse: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                          HomeCubit.get(context).changeIndex(2);
                        },
                        onTapChapter: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                          HomeCubit.get(context).changeIndex(2);
                        },
                        locale: Get.locale?.languageCode ?? 'ar',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
