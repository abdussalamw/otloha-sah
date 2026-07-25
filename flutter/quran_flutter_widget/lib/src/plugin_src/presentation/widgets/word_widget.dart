import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/model/word.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class WordWidget extends StatelessWidget {
  final Word? word;
  final String? customWords;
  final List<Verse> versesList;
  final List<Verse> selectedVerses;
  final Function(Verse verse) onLongPress;
  final Function(Verse verse) onTap;
  final double lineFontSize;
  final Widget? chapterImage;
  final Verse? playingVerse;
  final List<VerseStyle> verseStyles;
  // final Function(Verse verse) onDoubleTap;

  const WordWidget({
    Key? key,
    this.word,
    this.customWords,
    required this.selectedVerses,
    required this.versesList,
    required this.onLongPress,
    required this.onTap,
    required this.lineFontSize,
    this.chapterImage,
    this.playingVerse,
    required this.verseStyles,
    // required this.onDoubleTap,
  }) : super(key: key);

  static RegExp regExpNot = RegExp(r'[^٠-٩]');
  static RegExp regExp = RegExp(r'[٠-٩]');

  bool hasNumber() => regExp.hasMatch(customWords ?? word!.text);
  int numberLength() => regExp.allMatches(customWords ?? word!.text).length;

  @override
  Widget build(BuildContext context) {
    Verse? verse;
    if (word != null) {
      verse = versesList.firstWhere((element) => element.id == word!.verse);
    }
    void doubleTap() {
      if (customWords == null) {
        QuranCubit.get(context).selectCurrentVerse(verse!, word: word);
      }
      switch (QuranCacheRepository.lastPageType) {
        case 'PageType.tafsir':
          {
            QuranCubit.get(context).selectCurrentVerse(verse!);
            QuranCubit.get(context).setPageType(PageType.tafsir);
            break;
          }
        case 'PageType.tajwid':
          {
            QuranCubit.get(context).selectCurrentVerse(verse!, word: word);
            QuranCubit.get(context).setPageType(PageType.tajwid);
            break;
          }
        case 'PageType.translation':
          {
            QuranCubit.get(context).selectCurrentVerse(
              verse!,
            );
            QuranCubit.get(context).setPageType(PageType.translation);
            break;
          }
        default:
          {
            QuranCubit.get(context).selectCurrentVerse(verse!, word: word);
            QuranCubit.get(context).setPageType(PageType.tajwid);
          }
      }
    }

    Color? verseColor() {
      // print(verseStyles);
      if (customWords == null) {
        if (playingVerse != null && verse!.id == playingVerse!.id) {
          return Colors.red;
        }
        if (selectedVerses.contains(verse)) {
          return const Color.fromARGB(255, 0, 94, 255);
        }
        for (var item in verseStyles) {
          for (var id in item.verseIds) {
            if (id == verse!.id!) return item.textStyle.color;
          }
        }
      }
      return null;
    }

    return chapterImage ??
        GestureDetector(
          onLongPress: customWords != null ? () {} : () => onLongPress(verse!),
          onTap: customWords != null ? () {} : () => onTap(verse!),
          onDoubleTap: () => doubleTap(),
          child: customWords == null
              ? hasNumber()
                  ? AutoSizeText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: word!.text.substring(
                                0, word!.text.length - numberLength()),
                            style: TextStyle(
                              fontFamily:
                                  QuranCacheRepository.narrationSelectedName ==
                                          'ورش'
                                      ? 'Warsh'
                                      : QuranCacheRepository
                                                  .narrationSelectedName ==
                                              'قالون'
                                          ? 'Qaloun'
                                          : 'Hafs20',
                              fontSize: lineFontSize,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${word!.text.substring(word!.text.length - numberLength() - 1, word!.text.length)} ',
                            style: TextStyle(
                              color: const Color(0xFF3fc6f1),
                              fontFamily:
                                  QuranCacheRepository.narrationSelectedName ==
                                          'ورش'
                                      ? 'Warsh'
                                      : QuranCacheRepository
                                                  .narrationSelectedName ==
                                              'قالون'
                                          ? 'Qaloun'
                                          : 'Hafs20',
                              fontSize: lineFontSize,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: verseColor(),
                        fontSize: lineFontSize,

                        fontFamily:
                            QuranCacheRepository.narrationSelectedName == 'ورش'
                                ? 'Warsh'
                                : QuranCacheRepository.narrationSelectedName ==
                                        'قالون'
                                    ? 'Qaloun'
                                    : 'Hafs20',
                        // wordSpacing: 3,
                      ),
                    )
                  : Text(
                      (customWords != null ? customWords! : word!.text),
                      style: TextStyle(
                        color: verseColor(),
                        fontSize: lineFontSize,

                        fontFamily:
                            QuranCacheRepository.narrationSelectedName == 'ورش'
                                ? 'Warsh'
                                : QuranCacheRepository.narrationSelectedName ==
                                        'قالون'
                                    ? 'Qaloun'
                                    : 'Hafs20',
                        // wordSpacing: 3,
                      ),
                    )
              : Text(
                  (customWords != null ? customWords! : word!.text),
                  style: TextStyle(
                    color: verseColor(),
                    fontSize: lineFontSize,
                    fontFamily: QuranCacheRepository.narrationSelectedName ==
                            'ورش'
                        ? 'Warsh'
                        : QuranCacheRepository.narrationSelectedName == 'قالون'
                            ? 'Qaloun'
                            : 'Hafs20',
                    // wordSpacing: 3,
                  ),
                ),
        );
  }
}
