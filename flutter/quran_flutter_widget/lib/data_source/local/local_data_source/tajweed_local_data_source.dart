import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';

class TajweedLocalDataSource {
  Future<List<TajweedBook>> findAllTajweed({
    String? qurey,
    int? narrationId,
  }) async {
    final db = await QuranDatabaseSource.instance.database;
    if (qurey == null && narrationId == null) {
      return db!.tajweedDao.findAllTajweed();
    } else if (qurey != null && narrationId != null) {
      return db!.tajweedDao.findAllTajweedQurey(qurey, narrationId);
    } else if (qurey != null) {
      return db!.tajweedDao.searchInTajweeds(qurey);
    } else if (narrationId != null) {
      return db!.tajweedDao.findTajweedInNarrationId(narrationId);
    }

    return db!.tajweedDao.findAllTajweed();
  }

  Future<TajweedBook?> findTajweedById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedDao.findTajweedById(id).first;
  }

  Future<void> insertTajweed(TajweedBook tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedDao.insertTajweed(tajweedModel);
  }

  Future<void> updateTajweed(TajweedBook tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedDao.updateTajweed(tajweedModel);
  }

  Future<void> deleteTajweed(TajweedBook tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedDao.deleteTajweed(tajweedModel);
  }

  Future<List<TajweedCharacters>?> findAllTajweedCharacters(
    int bookId, {
    int? chapter,
    int? verse,
    int? word,
  }) async {
    final db = await QuranDatabaseSource.instance.database;
    if (chapter != null) {
      return db!.tajweedWordDao.findAllTajweedChapter(bookId, chapter);
    }
    if (verse != null) {
      return db!.tajweedWordDao.findAllTajweedVerse(bookId, verse);
    }
    if (word != null) {
      return db!.tajweedWordDao.findAllTajweedWord(bookId, word);
    }
    return db!.tajweedWordDao.findAllTajweedCharacters(bookId);
  }

  Future<List<TajweedCharacters>> getSavedChaptersByBookId(int bookId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db!.tajweedWordDao.getSavedChaptersByBookId(bookId);
  }

  Future<List<TajweedCharacters>> findTajweedWordsInNarrationId(
      int bookId, int narrationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedWordDao
        .findTajweedWordsInNarrationId(bookId, narrationId);
  }

  Future<TajweedCharacters?> findTajweedWordById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedWordDao.findTajweedWordById(id).first;
  }

  Future<void> insertTajweedWord(TajweedCharacters tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedWordDao.insertTajweedWord(tajweedModel);
  }

  Future<void> updateTajweedWord(TajweedCharacters tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedWordDao.updateTajweedWord(tajweedModel);
  }

  Future<void> deleteTajweedWord(TajweedCharacters tajweedModel) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.tajweedWordDao.deleteTajweedWord(tajweedModel);
  }

  insertAllTajweed(List<TajweedBook> tajweedList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var element in tajweedList) {
      db!.tajweedDao.insertTajweed(element);
    }
  }

  insertAllTajweedCharacters(List<TajweedCharacters> list) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var element in list) {
      db!.tajweedWordDao.insertTajweedWord(element);
    }
  }
}
