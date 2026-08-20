import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';

class LevelsListing extends StatefulWidget {
  const LevelsListing({
    super.key,
    required this.lessonsPagingController,
  });
  
  final PagingController<int, TajweedLesson> lessonsPagingController;

  @override
  State<LevelsListing> createState() => _LevelsListingState();
}

class _LevelsListingState extends State<LevelsListing> {
  late PagingController<int, TajweedLevel> pagingController;

  @override
  void initState() {
    pagingController = PagingController<int, TajweedLevel>(firstPageKey: 1);
    super.initState();
    pagingController.addListener(() {
      if (pagingController.itemList != null &&
          pagingController.itemList!.isNotEmpty) {
        context
            .read<LevelCardCubit>()
            .selectLevel(pagingController.itemList!.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginationData<TajweedLevel>(
      initData: const [],
      getData: (next) {
        return ApiBaseHelper().getHTTP(
          '/api/v1/tajweed/levels/',
          dioTypes: DioTypes.noAuthRequired,
        );
      },
      scrollDirection: Axis.horizontal,
      drowItem: (level, idx) => LevelCard(
        pagingController: pagingController,
        lessonsPagingController: widget.lessonsPagingController,
        level: level,
      ),
      pagingController: pagingController,
    );
  }
}

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.pagingController,
    required this.lessonsPagingController,
    required this.level,
  });

  final PagingController<int, TajweedLevel> pagingController;
  final PagingController<int, TajweedLesson> lessonsPagingController;
  final TajweedLevel level;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LevelCardCubit, LevelCardState>(
      builder: (context, state) {
        final isSelected = state is LevelCardSelected && state.tajweedLevel == level;

        return GestureDetector(
          onTap: () {
            context.read<LevelCardCubit>().selectLevel(level);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
              borderRadius: AppRadius.radiusFull,
              border: Border.all(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                level.name.translate() ?? '',
                style: AppTypography.bodyMedium(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ).copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
