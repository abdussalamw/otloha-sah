import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/lessons_listing.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/levels_listing.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/progress_card.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/widgets/tool_bar_app.dart';

class TajweedLevelsPage extends StatelessWidget {
  static const String routeName = 'tajweed_page';
  TajweedLevelsPage({super.key});

  final PagingController<int, TajweedLesson> pagingController =
      PagingController<int, TajweedLesson>(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            ToolBarApp(
              backIcon: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: 'أحكام التجويد والدروس',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    BlocBuilder<LevelCardCubit, LevelCardState>(
                      builder: (context, state) {
                        if (state is LevelCardSelected) {
                          return ProgressCard(level: state.tajweedLevel);
                        }
                        return ProgressCard(
                          level: TajweedLevel(
                            name: const Translations(
                              translations: {'ar': 'التجويد', 'en': 'Tajweed'},
                            ),
                            completed: 0,
                            id: 0,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 38,
                      child: LevelsListing(lessonsPagingController: pagingController),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: BlocConsumer<LevelCardCubit, LevelCardState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is LevelCardSelected) {
                            return LessonsListing(
                              level: state.tajweedLevel,
                              pagingController: pagingController,
                            );
                          }
                          return const Center(child: SizedBox());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
