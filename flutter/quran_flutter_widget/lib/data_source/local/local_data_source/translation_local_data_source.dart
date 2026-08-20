import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';

class TranslationLocalDataSource {
  Future<List<Translation>?> findAllTranslation() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.translationDao.findAllTranslation();
  }

  Future<Translation?> findTranslationById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.translationDao.findTranslationById(id).last;
  }

  Future<TranslationVerse?> findTranslationVerseByVerseId(
      int translationId, int verseNumber, int chapterNumber) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db?.translationVerseDao.findTranslationVerseByVerseId(
        translationId, verseNumber, chapterNumber);
  }

  Future<void> insertTranslationList(List<Translation> tranList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var tran in tranList) {
      await db?.translationDao.insertTranslation(tran);
    }
  }

  Future<void> insertTranslation(Translation tran) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationDao.insertTranslation(tran);
  }

  Future<void> updateTranslation(Translation tran) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationDao.updateTranslation(tran);
  }

  Future<void> deleteTranslation(Translation tran) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationDao.deleteTranslation(tran);
  }

  Future<List<TranslationVerse>?> findAllTranslationVerses(int translation,
      {int? chapter}) async {
    final db = await QuranDatabaseSource.instance.database;

    final verses = await db?.translationVerseDao
        .findAllTranslationVerses(translation);
    if (chapter == null) {
      return verses;
    }
    return verses
        ?.where((verse) => verse.chapterNumber == chapter)
        .toList();
  }

  Future<TranslationVerse?> findTranslationVerseById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.translationVerseDao.findTranslationVerseById(id).last;
  }

  Future<List<TranslationVerse>?> getSavedChaptersByBookId(int bookId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db!.translationVerseDao.getSavedChaptersByBookId(bookId);
  }

  Future<void> insertTranslationVerseList(
      List<TranslationVerse> tranList) async {
    final db = await QuranDatabaseSource.instance.database;
    print('save translation verse list');
    await db?.translationVerseDao.insertTranslationVerseList(tranList);
  }

  Future<void> updateTranslationVerse(TranslationVerse tran) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationVerseDao.updateTranslationVerse(tran);
  }

  Future<void> deleteTranslationVerse(TranslationVerse tran) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationVerseDao.deleteTranslationVerse(tran);
  }

  insertTranslationVerse(TranslationVerse translationVerse) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.translationVerseDao.insertTranslationVerse(translationVerse);
  }
}
