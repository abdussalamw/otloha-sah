import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import 'package:quran_widget_flutter/src/plugin_src/presentation/pages/tafsir_page.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/pages/tajwid_page.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/pages/translation_page.dart';

class ControllerPage extends StatelessWidget {
  const ControllerPage({
    Key? key,
    required this.pageType,
    required this.cubit,
    required this.onChapterChange,
    required this.isDark,
  }) : super(key: key);

  final PageType pageType;
  final QuranCubit cubit;
  final Function(Chapter chapter) onChapterChange;

  final bool isDark;

  List<DropdownMenuItem<PageType>> get getItems => [
        DropdownMenuItem<PageType>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AutoSizeText(
                'تجويد',
                minFontSize: 28,
                style: TextStyle(
                  fontFamily: 'Hafs20',
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Image.asset(
                'assets/icons/quran2.png',
                width: 20,
                height: 20,
                color: const Color(0xff24BDEF),
              ),
            ],
          ),
          value: PageType.tajwid,
        ),
        DropdownMenuItem<PageType>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AutoSizeText(
                'تفسير',
                minFontSize: 28,
                style: TextStyle(
                  fontFamily: 'Hafs20',
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Image.asset(
                'assets/icons/quran4.png',
                width: 20,
                height: 20,
                color: const Color(0xff24BDEF),
              ),
            ],
          ),
          value: PageType.tafsir,
        ),
        DropdownMenuItem<PageType>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AutoSizeText(
                'ترجمة',
                minFontSize: 28,
                style: TextStyle(
                  fontFamily: 'Hafs20',
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Image.asset(
                'assets/icons/language.png',
                width: 20,
                height: 20,
                color: const Color(0xff24BDEF),
              ),
            ],
          ),
          value: PageType.translation,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PageType>(
              items: getItems,
              onChanged: onChanged,
              elevation: 0,
              icon: const Icon(Icons.expand_more),
              borderRadius: BorderRadius.zero,
              value: pageType,
              // disabledHint: getDisableHint(),
            ),
          ),
        ),
        Expanded(
          child: display(),
        ),
      ],
    );
  }

  display() {
    switch (pageType) {
      case PageType.tafsir:
        {
          return TafsirPage(
            onChapterChange: onChapterChange,
            cubit: cubit,
            isDark: isDark,
          );
        }
      case PageType.tajwid:
        {
          return TajwidPage(
            onChapterChange: onChapterChange,
            cubit: cubit,
            isDark: isDark,
          );
        }
      case PageType.translation:
        {
          return TranslationPage(
            onChapterChange: onChapterChange,
            cubit: cubit,
            isDark: isDark,
          );
        }

      default:
        {
          return TajwidPage(
            onChapterChange: onChapterChange,
            cubit: cubit,
            isDark: isDark,
          );
        }
    }
  }

  void onChanged(PageType? pageType) {
    //  changeVerse(pageType);
    cubit.setPageType(pageType ?? PageType.tajwid);
  }

  getDisableHint() {
    switch (pageType) {
      case PageType.tafsir:
        {
          return getItems[1].child;
        }
      case PageType.tajwid:
        {
          return getItems[0].child;
        }
      case PageType.translation:
        {
          return getItems[2].child;
        }

      default:
        {
          return getItems[0].child;
        }
    }
  }

  // void changeVerse(PageType? pageType) {
  //    switch (QuranCacheRepository.lastPageType) {
  //       case 'PageType.tafsir':
  //         {
  //           cubit.setTafasirSelectedVerse(verse!);
  //           break;
  //         }
  //       case 'PageType.tajwid':
  //         {
  //           cubit.setTajweedSelectedVerse(verse!);
  //           break;
  //         }
  //       case 'PageType.translation':
  //         {
  //           cubit.setTargamaSelectedVerse(verse!);
  //           break;
  //         }
  //       default:
  //         {
  //           cubit.setTajweedSelectedVerse(verse!);
  //         }
  //     }
  // }
}
