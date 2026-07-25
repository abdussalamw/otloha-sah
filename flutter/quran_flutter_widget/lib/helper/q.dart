import 'package:flutter/material.dart';

class Q {
  /// *** Constants ***

  static const bool isConnect = false;

  static const String hafsSmart = 'HafsSmart';
  static const String bazzi1 = 'Bazzi1';
  static const String doori = 'Doori';
  static const String hafs15 = 'Hafs15';
  static const String hafs17 = 'Hafs17';
  static const String qaloon = 'assets/fonts/uthmanic_qaloon1_ver10.ttf';
  static const String qumbul = 'assets/fonts/uthmanic_qumbul1_ver07.ttf';
  static const String shouba = 'assets/fonts/uthmanic_shouba1_ver08.ttf';
  static const String soosi = 'assets/fonts/uthmanic_soosi1_ver09.ttf';
  static const String warsh = 'assets/fonts/uthmanic_warsh1_ver10.ttf';
  static const String tn = 'assets/fonts/uthmantn1ver10_0.ttf';
  static const String tn1b = 'assets/fonts/uthmantn8b_ver10.ttf';
  static const String quranKarim = 'QuranKarim';
  static const String pages = 'pages';
  static const String lastPageType = 'lastPageType';
  static const String selectedWord = 'selectedWord';
  static const String selectedVerses = 'selectedVerses';
  static const String currentVerse = 'currentVerse';

  static const String versionName = '';
  static const String appName = 'Quran Widget';

  static double deviceWidth = 0.0;
  static double deviceHeight = 0.0;

  static const Locale selectedLocale = localeAR;
  static const localeAR = Locale('ar', 'EG');
  static const localeEN = Locale('en', 'US');

  static var supportedLanguages = [
    localeAR,
    localeEN,
  ];

  static const String languageSettingKey = 'language';

  static const String languageSettingEnglishValue = 'en';
  static const String languageSettingArabicValue = 'en';

  static const String lastPageId = 'lastPageId';
  static const String lastPageNumber = 'lastPageNumber';

  static const String bookSelectedId = 'BookSelectedId';
  static const String bookSelectedName = 'BookSelectedName';
  static const String narrationSelectedId = 'NarrationSelectedId';
  static const String narrationSelectedName = 'NarrationSelectedName';
  static const String qtlSelectedId = 'QuranTranslationLanguageSelectedID';
  static const String qtlSelectedName = 'QuranTranslationLanguageSelectedName';
  static const String tafseerSelectedId = 'TafseerSelectedId';
  static const String tafseerSelectedName = 'TafseerSelectedName';
  static const String reciterSelectedId = 'ReciterSelectedId';
  static const String reciterSelectedName = 'ReciterSelectedName';
  static const String tajweedSelectedId = 'TajweedSelectedId';
  static const String tajweedSelectedName = 'TajweedSelectedName';
  static const String chapterSelectedId = 'ChapterID';
  static const String chapterSelectedName = 'ChapterName';
  static const String recitationSelectedId = 'RecitationSelectedId';
  static const String recitationSelectedName = 'RecitationSelectedName';
  static const String initDataIsSetted = 'initDataIsSetted';
  static const String allVerses = 'allVerses';

  static const String tafsir = 'assets/icon/tafsir.png';
  static const String tagwid = 'assets/icon/tagwid.png';
  static const String translate = 'assets/icon/translate.png';
}
