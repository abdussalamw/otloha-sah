import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/widgets/page_widget.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({
    Key? key,
    required this.onTap,
    required this.onLongTap,
    required this.onPageChange,
    required this.cubit,
    required this.controller,
    required this.onChapterChange,
    this.playingVerse,
  }) : super(key: key);

  final QuranController controller;
  final Function(bool isSelectedVerse, List<Verse>? selectedVerses) onTap;
  final Function(bool isSelectedVerse, List<Verse>? selectedVerses) onLongTap;

  final Function(int pageNumber) onPageChange;
  final Function(Chapter chapter) onChapterChange;
  final QuranCubit cubit;
  final Verse? playingVerse;
  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();
    // widget.controller.setCubit(QuranCubit.get(context));
  }

  @override
  Widget build(BuildContext context) {
    var cubit = QuranCubit.get(context);
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (context, state) {
        if (state is ChapterChangedState) {
          widget.onChapterChange(state.chapter);
        }
      },
      builder: (context, state) {
        if (state is PagesFetchErrorState) {
          return Center(child: Text(state.error));
        }
        if (state is PagesFetchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return InteractiveViewer(
          maxScale: 10,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: PageView.builder(
              controller: cubit.pageController,
              itemCount: cubit.pages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cubit.currentPart == null
                                ? ''
                                : cubit.currentPart!.name!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF3A7BD5),
                              fontFamily: 'Hafs20',
                            ),
                          ),
                          Text(
                            cubit.currentChapter == null
                                ? ''
                                : cubit.currentChapter!.name!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF3A7BD5),
                              fontFamily: 'Hafs20',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageWidget(
                        verses: cubit.pages.values.toList().elementAt(index),
                        playingVerse: widget.playingVerse,
                        onLongPressed: (Verse verse) {
                          cubit.onLongTap(verse);
                          widget.onLongTap(
                              cubit.isSelected, cubit.selectedVerses);
                        },
                        onTap: (Verse verse) {
                          cubit.onTap(verse);
                          widget.onTap(cubit.isSelected, cubit.selectedVerses);
                        },
                        // ─── مرحلة 3: ضغطة مزدوجة موحدة ───
                        onDoubleTap: (Verse verse) {
                          cubit.doubleTapVerse(verse);
                        },
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (int pageIndex) {
                int currentPageNumber =
                    cubit.pages.keys.toList().elementAt(pageIndex);
                cubit.slide(currentPageNumber);
                widget.onPageChange(currentPageNumber);
                widget.onChapterChange(cubit.currentChapter!);
              },
            ),
          ),
        );
      },
    );
  }
}
