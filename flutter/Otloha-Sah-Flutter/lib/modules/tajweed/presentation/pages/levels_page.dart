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

class TajweedLevelsPage extends StatelessWidget {
  static const String routeName = 'tajweed_page';
  TajweedLevelsPage({super.key});

  final PagingController<int, TajweedLesson> pagingController =
      PagingController<int, TajweedLesson>(firstPageKey: 1);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 15),
              SizedBox(
                height: 30,
                child: LevelsListing(lessonsPagingController: pagingController),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: BlocConsumer<LevelCardCubit, LevelCardState>(
                  listener: (context, state) {
                    // pagingController.refresh();
                  },
                  builder: (context, state) {
                    if (state is LevelCardSelected) {
                      return LessonsListing(
                        level: state.tajweedLevel,
                        pagingController: pagingController,
                      );
                    }
                    return const Center(
                      child: SizedBox(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
