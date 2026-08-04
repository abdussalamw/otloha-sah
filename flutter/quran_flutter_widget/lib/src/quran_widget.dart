import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/helper/q.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/pages/controller_page.dart';

import 'package:quran_widget_flutter/src/plugin_src/presentation/pages/quran_page.dart';

class QuranWidget extends StatefulWidget {
  const QuranWidget({
    Key? key,
    required this.page,
    required this.chapterId,
    required this.bookId,
    required this.narrationId,
    required this.onTap,
    required this.onLongTap,
    required this.onPageChange,
    required this.onChapterChange,
    required this.controller,
    required this.onPageTypeChage,
    this.isDark = false,
    this.playingVerse,
    this.verseStyles,
    this.playerController,
    this.locale,
    this.onPlay,
  }) : super(key: key);

  final PageType page;
  final int chapterId;
  final int bookId;
  final bool isDark;
  final int narrationId;
  final Verse? playingVerse;
  final QuranController controller;
  final List<VerseStyle>? verseStyles;
  final dynamic playerController;
  final dynamic locale;
  final dynamic onPlay;

  final Function(int pageNumber) onPageChange;
  final Function(PageType pageType) onPageTypeChage;

  final Function(
    bool isVerseSelected,
    List<Verse>? selectedVerses,
  ) onTap;

  final Function(
    bool isVerseSelected,
    List<Verse>? selectedVerses,
  ) onLongTap;

  final Function(Chapter? chapter) onChapterChange;

  @override
  State<QuranWidget> createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = QuranCubit(
          narrationId: widget.narrationId,
          bookId: widget.bookId,
          isDark: widget.isDark,
        );
        cubit.fetchInitailPages(context).catchError((e) {
          print('Error during initial fetchInitailPages: $e');
        });
        widget.controller.setCubit(cubit);
        return cubit;
      },
      child: BlocConsumer<QuranCubit, QuranState>(
        listener: (context, state) async {
          if (state is QuranInitialState) {
            await CacheHelper.saveData(
                key: Q.narrationSelectedId, value: widget.narrationId);
            await CacheHelper.saveData(
                key: Q.narrationSelectedName, value: widget.bookId);
          } else if (state is ChapterChangedState) {
            widget.onChapterChange(QuranCubit.get(context).currentChapter);
          }
        },
        builder: (context, state) {
          var cubit = QuranCubit.get(context);
          print('cubit $cubit');
          QuranCubit.get(context).setVersesStyles(widget.verseStyles ?? []);
          // cubit.currentPageType = widget.page;
          if (state is ChangePageState) {
            widget.onPageTypeChage(cubit.currentPageType);
            cubit.onPress();
          } else {
            cubit.currentPageType = widget.page;
          }
          return body(cubit);
        },
      ),
    );
  }

  display(QuranCubit cubit) {
    switch (cubit.currentPageType) {
      case PageType.quran:
        {
          return QuranPage(
            controller: widget.controller,
            onTap: widget.onTap,
            onLongTap: widget.onLongTap,
            cubit: cubit,
            onPageChange: widget.onPageChange,
            onChapterChange: widget.onChapterChange,
            playingVerse: widget.playingVerse,
          );
        }

      default:
        {
          return ControllerPage(
            cubit: cubit,
            pageType: cubit.currentPageType,
            onChapterChange: widget.onChapterChange,
            isDark: widget.isDark,
          );
        }
    }
  }

  Widget body(QuranCubit cubit) {
    return Container(
      // color: const Color(0xFFF9F9F9),
      // padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 0),
      child: display(cubit),
    );
  }
}

// for (int pageNumber = 1;
//     pageNumber <= allVerses.last.pageNumber!;
//     pageNumber++) {
//   List<Verse> versesInPage = allVerses
//       .where((element) => element.pageNumber == pageNumber)
//       .toList();
//   if (versesInPage.isNotEmpty) {
//     for (int line = 1; line <= versesInPage.last.lineEnd!; line++) {
//       double lineFontSize =
//           getLineFontSize(getLineText(versesInPage, line), context);
//       for (int verseInPage = 0;
//           verseInPage < versesInPage.length;
//           verseInPage++) {
//         for (int wordinVerse = 0;
//             wordinVerse < versesInPage[verseInPage].words!.length;
//             wordinVerse++) {
//           versesInPage[verseInPage].words![wordinVerse].fontSize =
//               lineFontSize;
//         }
//       }

//       if (versesInPage.first.words!.isNotEmpty)
//         print(versesInPage.first.words!.first.fontSize);
//     }
//     int start = allVerses.indexOf(versesInPage.first);
//     int end = allVerses.indexOf(versesInPage.last);
//     // allVerses.replaceRange(start, end, versesInPage);
//   }
// }
