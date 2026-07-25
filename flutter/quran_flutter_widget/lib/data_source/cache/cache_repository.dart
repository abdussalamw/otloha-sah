import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/helper/q.dart';

class QuranCacheRepository {
  static get selectedChapterId => CacheHelper.getData(key: Q.chapterSelectedId);
  static get selectedChapterName =>
      CacheHelper.getData(key: Q.chapterSelectedName);

  static setSelectedChapterId(int id) async =>
      await CacheHelper.saveData(key: Q.chapterSelectedId, value: id);
  static setSelectedChapterName(String name) async =>
      await CacheHelper.saveData(key: Q.chapterSelectedName, value: name);

  static get quranTranslationSelectedId =>
      CacheHelper.getData(key: Q.qtlSelectedId);
  static get quranTranslationSelectedName =>
      CacheHelper.getData(key: Q.qtlSelectedName);

  static setQuranTranslationSelectedId(int id) async =>
      await CacheHelper.saveData(key: Q.qtlSelectedId, value: id);
  static setQuranTranslationSelectedName(String name) async =>
      await CacheHelper.saveData(key: Q.qtlSelectedName, value: name);

  static get tafsirSelectedId => CacheHelper.getData(key: Q.tafseerSelectedId);
  static get tafsirSelectedName =>
      CacheHelper.getData(key: Q.tafseerSelectedName);

  static setTafsirSelectedId(int id) async =>
      await CacheHelper.saveData(key: Q.tafseerSelectedId, value: id);
  static setTafsirSelectedName(String name) async =>
      await CacheHelper.saveData(key: Q.tafseerSelectedName, value: name);

  static get bookSelectedId => CacheHelper.getData(key: Q.bookSelectedId);
  static get bookSelectedName => CacheHelper.getData(key: Q.bookSelectedName);

  static setBookSelectedId(int id) async =>
      await CacheHelper.saveData(key: Q.bookSelectedId, value: id);
  static setBookSelectedName(String name) async =>
      await CacheHelper.saveData(key: Q.bookSelectedName, value: name);

  static get narrationSelectedId =>
      CacheHelper.getData(key: Q.narrationSelectedId);
  static String get narrationSelectedName =>
      CacheHelper.getData(key: Q.narrationSelectedName);

  static setNarrationSelectedId(int id) async =>
      await CacheHelper.saveData(key: Q.narrationSelectedId, value: id);
  static setNarrationSelectedName(String name) async =>
      await CacheHelper.saveData(key: Q.narrationSelectedName, value: name);

  static get selectedReciterId => CacheHelper.getData(key: Q.reciterSelectedId);
  static get selectedReciterName =>
      CacheHelper.getData(key: Q.reciterSelectedName);

  static setSelectedReciterId(int id) async =>
      await CacheHelper.saveData(key: Q.reciterSelectedId, value: id);
  static setSelectedReciterName(String name) async =>
      await CacheHelper.saveData(key: Q.reciterSelectedName, value: name);

  static int? get selectedTajweedId =>
      CacheHelper.getData(key: Q.tajweedSelectedId);
  static get selectedTajweedName =>
      CacheHelper.getData(key: Q.tajweedSelectedName);

  static setSelectedTajweedId(int id) async =>
      await CacheHelper.saveData(key: Q.tajweedSelectedId, value: id);
  static setSelectedTajweedName(String name) async =>
      await CacheHelper.saveData(key: Q.tajweedSelectedName, value: name);

  static get selectedRecitationId =>
      CacheHelper.getData(key: Q.recitationSelectedId);
  static String? get selectedRecitationName =>
      CacheHelper.getData(key: Q.recitationSelectedName);
  static setSelectedRecitationId(int id) async =>
      await CacheHelper.saveData(key: Q.recitationSelectedId, value: id);
  static setSelectedRecitationName(String name) async =>
      await CacheHelper.saveData(key: Q.recitationSelectedName, value: name);

  static bool? get initDataIsSetted =>
      CacheHelper.getData(key: Q.initDataIsSetted);
  static Future<void> initDataSetted() =>
      CacheHelper.saveData(key: Q.initDataIsSetted, value: true);

  static get lastPageNumber => CacheHelper.getData(key: Q.lastPageNumber);
  static Future<void> setLastPageNumber(int pageNumber) =>
      CacheHelper.saveData(key: Q.lastPageNumber, value: pageNumber);

  static saveLastPageType(String page) async {
    await CacheHelper.saveData(key: Q.lastPageType, value: page);
  }

  static String? get lastPageType => CacheHelper.getData(key: Q.lastPageType);
}
