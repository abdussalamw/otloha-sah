import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';

import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/helper/q.dart';
import 'package:quran_widget_flutter/helper/utils.dart';
import 'package:quran_widget_flutter/model/word.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/data/quran_service.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/widgets/word_widget.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(
      {required this.narrationId, required this.bookId, required this.isDark})
      : super(QuranInitialState()) {
    pageController = PageController();
    currentPageNumber = QuranCacheRepository.lastPageNumber ?? 1;
  }

  final int narrationId;
  final int bookId;
  final bool isDark;
  Function(Verse verse)? onLongTapCallback;
  Function(Verse verse)? onTapCallback;
  Verse? playingVerse;

  List<VerseStyle> verseStyles = [];

  static QuranCubit get(context) => BlocProvider.of(context);

  final VersesLocalDataSource _versesLocalDataSource = VersesLocalDataSource();

  late PageController pageController;

  List<Verse> selectedVerses = [];

  SplayTreeMap<int, List<Verse>> pages = SplayTreeMap<int, List<Verse>>();
  bool isSelected = false;
  PageType currentPageType = PageType.quran;

  PageController? tajweedPageController;
  PageController? translationPageController;
  PageController? tafsirPageController;

  Word? _selectedTajweedWord;
  static Verse? _currentVerse;

  static Verse? get currentVerse => _currentVerse ?? allVerses.first;

  int currentPageNumber = 0;
  Chapter? currentChapter;
  Part? currentPart;
  late List<Chapter> chapters;
  late List<Part> parts;
  List<List<Widget>> lines = [];
  static List<Verse> allVerses = QuranService.instance.allVerses;

  void selectCurrentVerse(Verse verse, {Word? word}) {
    //tajweedPageController = PageController(initialPage: verse.verseNumber! - 1);
    _selectedTajweedWord = word;
    _currentVerse = verse;

    if (chapters.isEmpty) return;

    Chapter crnChapter = chapters.firstWhere(
      (chapter) => chapter.chapterNumber == verse.chapterNumber,
      orElse: () => chapters.first,
    );

    if (currentChapter == null ||
        crnChapter.chapterNumber != currentChapter!.chapterNumber) {
      currentChapter = crnChapter;
      QuranCacheRepository.setSelectedChapterId(currentChapter!.id!);
      QuranCacheRepository.setSelectedChapterName(currentChapter!.name ?? '');
      CacheHelper.saveData(
          key: Q.lastPageNumber, value: currentChapter!.pageFrom ?? 1);
    }
    if (word != null) {
      CacheHelper.saveData(
          key: Q.selectedWord, value: json.encode(word.toJson()));
    }
  }

  Word? get selectedTajweedWord {
    if (_selectedTajweedWord == null) {
      if (CacheHelper.getData(key: Q.selectedWord) != null) {
        _selectedTajweedWord = Word.fromJson(
            json.decode(CacheHelper.getData(key: Q.selectedWord)));
      }
    }

    return _selectedTajweedWord;
  }

  List<Map<String, dynamic>> versesListToJson(List<Verse> verses) {
    List<Map<String, dynamic>> jsonVerses = [];
    for (var verse in verses) {
      jsonVerses.add(verse.toJson());
    }
    return jsonVerses;
  }

  List<Verse> versesListFromJson(List<dynamic> jsonVerses) {
    List<Verse> verses = [];
    for (var verse in jsonVerses) {
      verses.add(Verse.fromJson(verse));
    }
    return verses;
  }

  List<Verse> get cachedSelectedVerses {
    if (selectedVerses.isEmpty) {
      if (CacheHelper.getData(key: Q.selectedVerses) != null) {
        return versesListFromJson(
            json.decode(CacheHelper.getData(key: Q.selectedVerses)));
      }
    }

    return selectedVerses;
  }

  List<Verse> get getAllVerses {
    if (allVerses.isEmpty) {
      if (CacheHelper.getData(key: Q.allVerses) != null) {
        return versesListFromJson(
            json.decode(CacheHelper.getData(key: Q.allVerses)));
      }
    }
    return allVerses;
  }

  setPageType(PageType pageType) {
    QuranCacheRepository.saveLastPageType(pageType.toString());
    currentPageType = pageType;
    print('pageType: $pageType');

    if (pages.isEmpty) {
      emit(ChangePageState());
      return;
    }

    int rawIndex = (QuranCacheRepository.lastPageNumber ?? 1) - 1;
    final pagesList = pages.values.toList();
    if (rawIndex < 0 || rawIndex >= pagesList.length) {
      rawIndex = 0;
    }

    Verse? firstPageVerse = pagesList[rawIndex].isNotEmpty ? pagesList[rawIndex].first : (allVerses.isNotEmpty ? allVerses.first : null);

    if (firstPageVerse != null && currentVerse?.pageNumber == firstPageVerse.pageNumber) {
      firstPageVerse = currentVerse!;
    }

    int initialIndex = firstPageVerse != null ? allVerses.indexOf(firstPageVerse) : 0;
    if (initialIndex < 0) initialIndex = 0;

    switch (pageType) {
      case PageType.tafsir:
        {
          tafsirPageController =
              PageController(initialPage: initialIndex);
          break;
        }
      case PageType.tajwid:
        {
          tajweedPageController =
              PageController(initialPage: initialIndex);
          break;
        }
      case PageType.translation:
        {
          try {
            translationPageController = PageController();
            Future.microtask(() {
              translationPageController!
                  .jumpToPage(initialIndex);
            });
          } catch (e) {
            print(e);
          }
          break;
        }
      default:
        {
          pageController = PageController(
              initialPage: rawIndex);
        }
    }
    emit(ChangePageState());
  }

  onPress() {
    emit(OnPressState());
  }

  setVersesStyles(List<VerseStyle> verseStyles) {
    this.verseStyles = verseStyles;
    print(verseStyles);
  }

  fetchInitailPages(context) async {
    emit(PagesFetchLoadingState());

    try {
      int lastPageNumber = CacheHelper.getData(key: Q.lastPageNumber) ?? 1;

      parts = (await PartRepository().fetchPartsList()) ?? [];
      chapters = (await ChapterRepository().fetchChaptersList()) ?? [];

      if (chapters.isNotEmpty) {
        currentChapter = chapters.firstWhere(
          (element) =>
              (element.pageFrom ?? 1) <= lastPageNumber &&
              (element.pageTo ?? 604) >= lastPageNumber,
          orElse: () => chapters.first,
        );
      }

      allVerses = await QuranService.instance.allVersesAsync ?? [];

      if (allVerses.isNotEmpty && parts.isNotEmpty) {
        currentPart = parts.firstWhere(
          (element) => element.id == allVerses.first.partId,
          orElse: () => parts.first,
        );
      }

      pages.clear();
      for (var e in allVerses) {
        if (e.pageNumber != null) {
          if (!pages.containsKey(e.pageNumber)) pages[e.pageNumber!] = [];
          pages[e.pageNumber!]!.add(e);
        }
      }

      emit(PagesFetchedState(pages: pages));

      int targetIndex = 0;
      if (pages.isNotEmpty) {
        final rawIndex = pages.keys.toList().indexOf(lastPageNumber);
        targetIndex = rawIndex < 0 ? 0 : rawIndex;
      }

      if (pageController.hasClients) {
        pageController.jumpToPage(targetIndex);
      } else {
        pageController = PageController(initialPage: targetIndex);
      }

      currentPageNumber = lastPageNumber;
    } catch (e, s) {
      print('Error in fetchInitailPages: $e\n$s');
      emit(PagesFetchErrorState(error: e.toString()));
    }
  }

  updateChapter(Chapter chapter) {
    currentChapter = chapter;
    emit(ChapterChangedState(currentChapter!));
  }

  changeChapter(Chapter chapter) async {
    emit(PagesFetchLoadingState());

    currentChapter = chapter;

    QuranCacheRepository.setSelectedChapterId(chapter.id!);
    QuranCacheRepository.setSelectedChapterName(chapter.name!);
    CacheHelper.saveData(
        key: Q.lastPageNumber, value: currentChapter!.pageFrom!);
    if (pages.containsKey(currentChapter!.pageFrom)) {
      // emit(PagesFetchedState(pages: pages));
    } else {
      List<Verse> verses = await _versesLocalDataSource
          .filterVersesByPageNumberAndNarrationIdBetweenPages(
        startPage: currentChapter!.pageFrom! +
            (currentChapter!.pageFrom! == 1 ? 0 : -1),
        endPage: currentChapter!.pageFrom! + 1,
        narrationId: narrationId,
      );

      for (var e in verses) {
        if (!pages.containsKey(e.pageNumber)) pages[e.pageNumber!] = [];
        pages[e.pageNumber!]!.add(e);
      }
      emit(PagesFetchedState(pages: pages));
    }

    currentPageNumber = currentChapter!.pageFrom!;

    if (currentPageType == PageType.quran) {
      Future.delayed(const Duration(milliseconds: 10)).then((value) {
        pageController
            .jumpToPage(pages.keys.toList().indexOf(currentChapter!.pageFrom!));
      });
    }

    emit(ChapterChangedState(chapter));

    if (currentPageType != PageType.quran) {
      List<Verse> verses = allVerses
          .where((element) => chapter.chapterNumber == element.chapterNumber)
          .toList();

      verses.sort(
        (a, b) {
          return a.verseNumber!.compareTo(b.verseNumber!);
        },
      );
      Verse verseSel = verses.last;

      // var verse = allVerses.firstWhere(
      //     (element) => chapter.chapterNumber == element.chapterNumber);

      print('verse $verseSel');
      selectCurrentVerse(verseSel);

      switch (currentPageType) {
        case PageType.tafsir:
          {
            tafsirPageController!.jumpToPage(allVerses.indexOf(currentVerse!));
            break;
          }
        case PageType.tajwid:
          {
            tajweedPageController!.jumpToPage(allVerses.indexOf(currentVerse!));
            break;
          }
        case PageType.translation:
          {
            translationPageController!
                .jumpToPage(allVerses.indexOf(currentVerse!));
            break;
          }
        case PageType.quran:
          break;
      }
      //return;
    }

    return pages.keys.toList().indexOf(currentChapter!.pageFrom!);
  }

  slide(int pageNumber) {
    int lastPage = CacheHelper.getData(key: Q.lastPageNumber) ?? 1;
    List<Chapter> selectedChapters = chapters
        .where((element) =>
            (element.pageFrom ?? 1) <= pageNumber && (element.pageTo ?? 604) >= pageNumber)
        .toList();

    if (pages.containsKey(pageNumber) && pages[pageNumber]!.isNotEmpty) {
      int? partId = pages[pageNumber]!.first.partId;
      if (currentPart == null || currentPart!.id != partId) {
        if (parts.isNotEmpty) {
          currentPart = parts.firstWhere(
            (element) => element.id == partId,
            orElse: () => parts.first,
          );
          emit(PartChangedState());
        }
      }
    }

    if (selectedChapters.isNotEmpty && !selectedChapters.contains(currentChapter)) {
      currentChapter = selectedChapters.first;
      emit(ChapterChangedState(currentChapter!));
      if (currentChapter!.id != null) QuranCacheRepository.setSelectedChapterId(currentChapter!.id!);
      if (currentChapter!.name != null) QuranCacheRepository.setSelectedChapterName(currentChapter!.name!);
    }
    currentPageNumber = pageNumber;
    if (lastPage > pageNumber) {
      slideToPreviousPage(pageNumber: pageNumber);
    } else if (lastPage < pageNumber) {
      slideToNextPage(pageNumber: pageNumber);
    }
    CacheHelper.saveData(key: Q.lastPageNumber, value: pageNumber);
  }

  fetchNextPage({required int currentPageNumber}) async {
    if (!pages.containsKey(currentPageNumber + 1) && currentPageNumber > 604) {
      pages[currentPageNumber + 1] =
          await _versesLocalDataSource.filterVersesByPageNumberAndNarrationId(
              pageNumber: currentPageNumber + 1, narrationId: narrationId);
    }
  }

  fetchPreviousPage({required currentPageNumber}) async {
    if (currentPageNumber != 1 && !pages.containsKey(currentPageNumber - 1)) {
      List<Verse> verses =
          await _versesLocalDataSource.filterVersesByPageNumberAndNarrationId(
              pageNumber: currentPageNumber - 1, narrationId: narrationId);

      if (!pages.containsKey(currentPageNumber - 1)) {
        pages[currentPageNumber - 1] = verses;
        pageController
            .jumpToPage(pages.keys.toList().indexOf(currentPageNumber));
      }
    }
  }

  slideToNextPage({required int pageNumber}) async {
    await fetchNextPage(currentPageNumber: pageNumber);
    emit(FetchNextPageState());
  }

  slideToPreviousPage({required int pageNumber}) async {
    await fetchPreviousPage(currentPageNumber: pageNumber);
    emit(FetchPreviousPageState());
  }

  onTap(Verse verse) async {
    if (selectedVerses.isNotEmpty) {
      if (selectedVerses.contains(verse)) {
        selectedVerses.clear();
      } else {
        List<Verse> verses = [];
        if (selectedVerses.last.pageNumber != verse.pageNumber) {
          pageController.jumpToPage(selectedVerses.last.pageNumber! - 1);
        }
        if (selectedVerses.last.id! < verse.id!) {
          verses = allVerses
              .where((element) =>
                  selectedVerses.last.id! <= element.id! &&
                  element.id! <= verse.id! &&
                  selectedVerses.last.pageNumber == element.pageNumber)
              .toList();
        } else {
          verses = allVerses
              .where((element) =>
                  selectedVerses.first.id! > element.id! &&
                  element.id! >= verse.id! &&
                  selectedVerses.last.pageNumber == element.pageNumber)
              .toList();
        }

        selectedVerses.addAll(verses);
        selectedVerses.sort((a, b) => a.id!.compareTo(b.id!));

        CacheHelper.saveData(
            key: Q.selectedVerses,
            value: json.encode(versesListToJson(selectedVerses)));
      }
    }
    emit(OnPressState());
  }

  onLongTap(Verse verse) async {
    if (selectedVerses.isEmpty) {
      selectedVerses.add(verse);
      CacheHelper.saveData(
          key: Q.selectedVerses,
          value: json.encode(versesListToJson(selectedVerses)));
    } else {
      await onTap(verse);
    }
    emit(OnLongPressState());
  }

  changePage(int pageNumber) {
    pageController.jumpToPage(pages.keys.toList().indexOf(pageNumber));
  }

  void versesWidgets(List<Verse> versesList, BuildContext context) {
    lines.clear();
    for (int i = 0; i < 15; i++) {
      lines.add([]);
    }
    for (var verse in versesList) {
      if (verse.verseNumber == 1) {
        if (versesList
            .where((element) => element.chapterNumber != verse.chapterNumber)
            .isNotEmpty) {
          int lineIdx = (verse.lineStart ?? 3) - 3;
          if (lineIdx >= 0 && lineIdx < lines.length && lines[lineIdx].isEmpty) {
            String chName = '';
            if (chapters.isNotEmpty) {
              var ch = chapters.firstWhere(
                (chapter) => chapter.chapterNumber == verse.chapterNumber,
                orElse: () => chapters.first,
              );
              chName = ch.name ?? '';
            }
            lines[lineIdx].add(
              WordWidget(
                lineFontSize: 22,
                selectedVerses: selectedVerses,
                versesList: versesList,
                onLongPress: onLongTapCallback!,
                onTap: onTapCallback!,
                playingVerse: playingVerse,
                verseStyles: verseStyles,
                customWords: chName,
                chapterImage: SvgPicture.asset(
                    isDark
                        ? 'assets/quran_assets/dark/${verse.chapterNumber ?? 1}.svg'
                        : 'assets/quran_assets/${verse.chapterNumber ?? 1}.svg',
                    width: MediaQuery.of(context).size.width - 5,
                    colorBlendMode: BlendMode.multiply),
              ),
            );
          }
        } else {
          int chNum = currentChapter?.chapterNumber ?? 1;
          lines[0].add(
            WordWidget(
              lineFontSize: 22,
              playingVerse: playingVerse,
              selectedVerses: selectedVerses,
              versesList: versesList,
              verseStyles: verseStyles,
              onLongPress: onLongTapCallback!,
              onTap: onTapCallback!,
              customWords:
                  '${currentChapter?.name ?? QuranCacheRepository.selectedChapterName}',
              chapterImage: Padding(
                padding: EdgeInsets.only(
                    bottom: chNum == 1 || chNum == 2 ? 40 : 0),
                child: SvgPicture.asset(
                  isDark
                      ? 'assets/quran_assets/dark/${verse.chapterNumber ?? 1}.svg'
                      : 'assets/quran_assets/${verse.chapterNumber ?? 1}.svg',
                  width: MediaQuery.of(context).size.width - 12,
                ),
              ),
            ),
          );
        }
        if (verse.chapterNumber != 9 && verse.chapterNumber != 1) {
          int basmalaIdx = (verse.lineStart ?? 2) - 2;
          if (basmalaIdx >= 0 && basmalaIdx < lines.length && lines[basmalaIdx].isEmpty) {
            lines[basmalaIdx].add(
              WordWidget(
                lineFontSize: 22,
                selectedVerses: selectedVerses,
                playingVerse: playingVerse,
                versesList: versesList,
                verseStyles: verseStyles,
                onLongPress: onLongTapCallback!,
                onTap: onTapCallback!,
                chapterImage: SvgPicture.asset(
                  isDark
                      ? 'assets/quran_assets/dark/basmala.svg'
                      : 'assets/quran_assets/basmala.svg',
                  width: 170,
                ),
              ),
            );
          }
        }
      }
      if (verse.words != null) {
        for (var word in verse.words!) {
          int wordLineIdx = (word.lineNumber ?? 1) - 1;
          if (wordLineIdx >= 0 && wordLineIdx < lines.length) {
            lines[wordLineIdx].add(
              WordWidget(
                lineFontSize: getLineFontSize(
                  getLineText(versesList, word.lineNumber ?? 1),
                  verse.pageNumber ?? 1,
                  word.lineNumber ?? 1,
                  context,
                ),
                playingVerse: playingVerse,
                verseStyles: verseStyles,
                selectedVerses: selectedVerses,
                versesList: versesList,
                onLongPress: onLongTapCallback!,
                onTap: onTapCallback!,
                word: word,
              ),
            );
          }
        }
      }
    }
    if (lines[0].length == 2) {
      lines[0].removeLast();
    }

    lines.removeWhere((element) => element.isEmpty);
    // emit(WordWidgetsCreated(lines));
    // emit(CreateWordsWidgets());
  }

  Size calcTextSize(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Hafs20',
        ),
      ),
      textDirection: TextDirection.rtl,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    // print('$text ${textPainter.size} $fontSize');
    return textPainter.size;
  }

  List<WordLinePage> wordLinePage = [];
  getLineFontSize(
      List<Word> words, int pageNumber, int lineNumber, BuildContext context) {
    String line = '';
    for (var word in words) {
      line += word.text;
    }
    line += ' ';

    double fontSize = 16;
    if (wordLinePage
        .where((element) =>
            element.page == pageNumber && element.line == lineNumber)
        .isNotEmpty) {
      double font = wordLinePage
          .firstWhere((element) =>
              element.page == pageNumber && element.line == lineNumber)
          .font;
      // print('$lineNumber $font');
      return font;
    }
    // print(Utils.deviceWidthInPixel(context));
    while (true) {
      if (calcTextSize(line, fontSize).width >=
              Utils.deviceWidthInPixel(context) - 50 ||
          fontSize >= (Utils.deviceWidthInPixel(context) > 500 ? 40 : 22)) {
        wordLinePage.add(
          WordLinePage(
            line: words.first.lineNumber!,
            page: pageNumber,
            font: fontSize - 3,
          ),
        );
        return fontSize - 3;
      } else {
        fontSize++;
      }
    }
  }

  List<Word> getLineText(List<Verse> versesList, int lineNumber) {
    List<Word> words = [];

    for (var element in versesList) {
      if (element.words != null) words.addAll(element.words!);
    }

    return words.where((element) => element.lineNumber == lineNumber).toList();
  }
}

class WordLinePage {
  int line;
  int page;
  double font;

  WordLinePage({
    required this.line,
    required this.page,
    required this.font,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WordLinePage &&
        other.font == font &&
        other.page == page &&
        other.line == line;
  }

  @override
  int get hashCode {
    return line.hashCode ^ page.hashCode ^ font.hashCode;
  }
}
