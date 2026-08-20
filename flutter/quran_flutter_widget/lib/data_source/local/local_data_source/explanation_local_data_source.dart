import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';

class ExplanationLocalDataSource {
  Future<List<Explanation>?> findAllExplanation() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationDao.findAllExplanation();
  }

  Future<List<Explanation>?> searchInExplanation({
    String? qurey,
    int? narrationId,
  }) async {
    final db = await QuranDatabaseSource.instance.database;
    if (qurey != null) {
      return db?.explanationDao.searchInExplanation(qurey);
    }
    if (narrationId != null) {
      return findExplanationsByNarrationId(narrationId);
    }
    return null;
  }

  Future<List<Explanation>?> findExplanationsByNarrationId(
      int narrationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationDao.findExplanationsByNarrationId(narrationId);
  }

  Future<Explanation?> findExplanationById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationDao.findExplanationById(id).last;
  }

  Future<void> insertExplanationList(List<Explanation> explList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var expl in explList) {
      await db?.explanationDao.insertExplanation(expl);
    }
  }

  Future<void> insertExplanation(Explanation expl) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.explanationDao.insertExplanation(expl);
  }

  Future<void> updateExplanation(Explanation expl) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.explanationDao.updateExplanation(expl);
  }

  Future<void> deleteExplanation(Explanation expl) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.explanationDao.deleteExplanation(expl);
  }

  Future<List<ExplanationVerse>?> findAllExplanationVerse(int explId,
      {int? chapter}) async {
    final db = await QuranDatabaseSource.instance.database;
    final verses = await db?.explanationVerseDao
        .findAllExplanationVerse(explId);
    if (chapter == null) {
      return verses;
    }
    return verses
        ?.where((verse) => verse.chapterNumber == chapter)
        .toList();
  }

  Future<List<ExplanationVerse>?> getSavedChaptersByBookId(int bookId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db!.explanationVerseDao.getSavedChaptersByBookId(bookId);
  }

  Future<List<ExplanationVerse>?> searchInExplanationVerse(String q) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationVerseDao.searchInExplanationVerse(q);
  }

  Future<List<ExplanationVerse>?> findExplanationVersesFliter(
    int? verse,
    int? chapter,
    int? page,
  ) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationVerseDao
        .findExplanationVersesFliterChapter(chapter ?? 1);
  }

  Future<ExplanationVerse?> findExplanationVerseById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.explanationVerseDao.findExplanationById(id).last;
  }

  Future<void> insertExplanationVerseList(
      List<ExplanationVerse> explList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var expl in explList) {
      await db?.explanationVerseDao.insertExplanationVerse(expl);
    }
  }

  Future<ExplanationVerse?> getExplanationVerseByVerseId(int verseId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db!.explanationVerseDao.findExplanationVersesByVerse(verseId);
  }

  Future<ExplanationVerse?> getExplanationVerseByVerseNumberAndChapter(int verseNumber, int chapterNumber, int explanationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db!.explanationVerseDao.findExplanationVersesByVerseNumberAndChapterAndExplanation(verseNumber, chapterNumber, explanationId);
  }

  Future<void> updateExplanationVerse(ExplanationVerse expl) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.explanationVerseDao.updateExplanationVerse(expl);
  }

  Future<void> deleteExplanationVerse(ExplanationVerse expl) async {
    final db = await QuranDatabaseSource.instance.database;

    await db?.explanationVerseDao.deleteExplanationVerse(expl);
  }
}
