import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
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

  late PagingController<int, TajweedLevel> pagingController;

  @override
  Widget build(BuildContext context) {
    return PaginationData<TajweedLevel>(
      initData: const [],
      getData: (next) {
        return ApiBaseHelper().getHTTP('/api/v1/tajweed/levels/',
            dioTypes: DioTypes.authRequired);
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
    return BlocBuilder<LevelCardCubit, LevelCardState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<LevelCardCubit>().selectLevel(level);
          },
          child: Container(
            // height: 100,
            margin: const EdgeInsetsDirectional.only(end: 16),
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff009EC0), width: 1.5),
              color: state is LevelCardSelected && state.tajweedLevel == level
                  ? const Color(0xff009EC0)
                  : null,
            ),
            child: Center(
              child: Text(
                level.name.translate() ?? '',
                style: TextStyle(
                  color:
                      state is LevelCardSelected && state.tajweedLevel == level
                          ? AppColor.white
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
