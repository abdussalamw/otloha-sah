import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/recitation_verses.dart';

class RecitationVersesLocalDataSource {
  Future<List<RecitationVerses>?> fetchRecitationsVersesList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationVersesDao.findAllRecitationsVerses();
  }

  Future<List<RecitationVerses>?> fetchRecitationsVersesChapterList(
      int chapterId, int recitationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationVersesDao
        .findRecitationVersesChapterList(chapterId, recitationId);
  }

  Future<RecitationVerses?> fetchRecitationVersesById(
      int recitationVersesId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationVersesDao
        .findRecitationVersesById(recitationVersesId)
        .first;
  }

  Future<void> saveRecitationsVersesList(
      List<RecitationVerses> recitationsVersesList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var recitationVerses in recitationsVersesList) {
      await db?.recitationVersesDao.insertRecitationVerses(recitationVerses);
    }
  }

  Future<void> deleteRecitationsVersesList(
      List<RecitationVerses> recitationsVersesList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var recitationVerses in recitationsVersesList) {
      await db?.recitationVersesDao.deleteRecitationVerses(recitationVerses);
    }
  }

  Future<void> updateRecitationVerses(RecitationVerses recitationVerses) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.recitationVersesDao.updateRecitationVerses(recitationVerses);
  }
}
