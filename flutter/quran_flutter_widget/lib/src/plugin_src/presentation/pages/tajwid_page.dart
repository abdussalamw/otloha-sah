import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/tajweed_cubit.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/tajweed_state.dart';

import '../../../../quran_widget_flutter.dart';

class TajwidPage extends StatelessWidget {
  const TajwidPage({
    Key? key,
    this.onTap,
    this.onLongTap,
    required this.cubit,
    required this.onChapterChange,
    required this.isDark,
  }) : super(key: key);

  final offset1 = const Offset(50, 200);
  final offset2 = const Offset(50, 300);

  final Function(String data, bool isVerseSelected)? onTap;
  final Function(String data, bool isVerseSelected)? onLongTap;
  final QuranCubit cubit;
  final Function(Chapter chapter) onChapterChange;

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: isDark
          ? const Color.fromARGB(255, 143, 188, 255)
          : const Color(0xFF08226C),
      fontSize: 16,
    );

    return BlocConsumer<QuranCubit, QuranState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PagesFetchErrorState) {
          return Center(child: Text(state.error));
        }
        if (state is PagesFetchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return BlocProvider(
          create: (context) => TajweedCubit()
            ..fetchVerseTajweedLetters(
              QuranCubit.currentVerse,
              selectedTajweedWord: cubit.selectedTajweedWord,
            ),
          child: BlocBuilder<TajweedCubit, TajweedState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: PageView.builder(
                  itemCount: QuranCubit.allVerses.length,
                  controller: cubit.tajweedPageController ??
                      PageController(initialPage: 0),
                  onPageChanged: (ind) => onPageChanged(ind, context),
                  itemBuilder: (context, index) {
                    return BlocBuilder<TajweedCubit, TajweedState>(
                      builder: (context, state) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      ...QuranCubit.allVerses[index].words!
                                          .map<Widget>((word) {
                                        return GestureDetector(
                                          onTap: TajweedCubit.get(context)
                                                          .isWordHasTajweed[
                                                      word.number] ??
                                                  false
                                              ? () {
                                                  TajweedCubit.get(context)
                                                      .fetchVerseTajweedWord(
                                                          word.number,
                                                          word.text,
                                                          word.id);
                                                }
                                              : null,
                                          child: Container(
                                            color: TajweedCubit.get(context)
                                                        .selected ==
                                                    word.id
                                                ? isDark
                                                    ? const Color.fromARGB(
                                                        255, 123, 107, 45)
                                                    : const Color(0xfffde174)
                                                : isDark
                                                    ? Colors.grey.shade800
                                                    : Colors.white,
                                            child: AutoSizeText(
                                              word.text + ' ',
                                              style: TextStyle(
                                                // color: Colors.black,
                                                fontSize: 25,
                                                fontFamily: 'Hafs20',
                                                decoration: TajweedCubit.get(
                                                                    context)
                                                                .isWordHasTajweed[
                                                            word.number] ??
                                                        false
                                                    ? TextDecoration.underline
                                                    : TextDecoration.none,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (state is TajweedErrorState)
                              Center(
                                child: Text(
                                  'تحقق من الاتصال بالانترنت',
                                  style: textStyle,
                                ),
                              ),
                            if (state is TajweedVerseLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (state is TajweedVerseFetchedState)
                              if (state.tajweedCharacters.isEmpty)
                                Center(
                                  child: Text(
                                    'التجويد غير متاح حاليا',
                                    style: textStyle,
                                  ),
                                )
                              else
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 0),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        if (TajweedCubit.get(context)
                                                .selectedText !=
                                            null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: AutoSizeText(
                                              TajweedCubit.get(context)
                                                      .selectedText ??
                                                  '',
                                              style: const TextStyle(
                                                // color: Colors.black,
                                                fontSize: 25,
                                                fontFamily: 'Hafs20',
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ...state.tajweedCharacters.map(
                                          (e) {
                                            // print('elment ${e.ruleText} ');
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              horizontalTitleGap: 4,
                                              minLeadingWidth: 20,
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Image.asset(
                                                  'assets/icons/tajwed_list.png',
                                                  color:
                                                      const Color(0xFF00D2FF),
                                                  width: 16,
                                                ),
                                              ),
                                              title: AutoSizeText(
                                                'الحرف ${e.characterText ?? ''} : ${e.ruleText ?? ''}',
                                                style: textStyle,
                                              ),
                                              style: ListTileStyle.list,
                                            );
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void onPageChanged(int pageIdx, BuildContext context) {
    cubit.selectCurrentVerse(
      QuranCubit.allVerses[pageIdx],
    );
    TajweedCubit.get(context).fetchVerseTajweedLetters(
        QuranCubit.allVerses[pageIdx],
        selectedTajweedWord: cubit.selectedTajweedWord);
    onChapterChange(cubit.currentChapter!);
  }
}
