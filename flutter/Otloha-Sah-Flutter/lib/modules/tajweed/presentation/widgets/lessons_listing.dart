import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/tajweed_lesson_card.dart';

class LessonsListing extends StatefulWidget {
  const LessonsListing({
    super.key,
    required this.level,
    required this.pagingController,
  });

  final TajweedLevel level;
  final PagingController<int, TajweedLesson> pagingController;

  @override
  State<LessonsListing> createState() => _LessonsListingState();
}

class _LessonsListingState extends State<LessonsListing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LessonsListing oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PaginationData<TajweedLesson>(
      initData: const [],
      getData: (next) {
        return ApiBaseHelper().getHTTP(
          '/api/v1/tajweed/levels/${widget.level.id}/lessons/',
          dioTypes: DioTypes.noAuthRequired,
        );
      },
      drowItem: (lesson, idx) => TajweedLessonCard(
        tajweedLesson: lesson,
      ),
      pagingController: widget.pagingController,
    );
  }
}
