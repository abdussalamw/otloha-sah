import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/model/word.dart';

class VersesLocalDataSource {
  Future<List<Verse>> findAllVerses() async {
    final db = await QuranDatabaseSource.instance.database;
    int narrationId = QuranCacheRepository.narrationSelectedId ?? 1;
    List<Verse>? verses = await db!.verseDao.findAllVerses(narrationId);
    if (verses.isNotEmpty) {
      List<Word> words = await db.wordDao
          .findWordsBetweenVerses(verses.first.id!, verses.last.id!);
      for (var word in words) {
        int idx = verses.indexWhere((element) => element.id == word.verse);
        if (idx != -1) {
          if (verses[idx].words == null) {
            verses[idx].words = [];
          }
          verses[idx].words!.add(word);
        }
      }
    }
    return verses;
  }

  Future<List<Verse>> findAllVersesByBookAndNarration(
      {required int narration, required int book}) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.verseDao.findAllVersesByBookAndNarration(narration, book);
  }

  Future<List<Verse>> findVersesBetween(int first, int last) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.verseDao.findVersesBetween(first, last);
  }

  Future<List<Verse>> findAllVersesChapterPage(
      {required int page, required int narration, required int book}) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.verseDao.findAllVersesChapterPage(page, narration, book);
  }

  Future<Stream<Verse?>> findVerseById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.verseDao.findVerseById(id);
  }

  Future<List<Verse>> filterVersesByPageNumberAndNarrationId(
      {required int pageNumber, required int narrationId}) async {
    final db = await QuranDatabaseSource.instance.database;
    List<Verse> verses = await db!.verseDao
        .filterVersesByPageNumberAndNarrationId(pageNumber, narrationId);
    if (verses.isNotEmpty) {
      List<Word> words = await db.wordDao
          .findWordsBetweenVerses(verses.first.id!, verses.last.id!);
      for (var word in words) {
        int idx = verses.indexWhere((element) => element.id == word.verse);
        if (idx != -1) {
          if (verses[idx].words == null) {
            verses[idx].words = [];
          }
          verses[idx].words!.add(word);
        }
      }
    }
    return verses;
  }

  Future<List<Verse>> filterVersesByPageNumberAndNarrationIdBetweenPages(
      {required int startPage,
      required int endPage,
      required int narrationId}) async {
    final db = await QuranDatabaseSource.instance.database;

    List<Verse>? verses = await db!.verseDao
        .filterVersesByPageNumberAndNarrationIdBetweenPages(
            narrationId, startPage, endPage);

    if (verses.isNotEmpty) {
      List<Word> words = await db.wordDao
          .findWordsBetweenVerses(verses.first.id!, verses.last.id!);

      for (int i = 0; i < verses.length; i++) {
        verses[i].words =
            words.where((element) => element.verse == verses[i].id).toList();
      }
    }

    return verses;
  }

  Future<void> insertVerse(Verse verse) async {
    final db = await QuranDatabaseSource.instance.database;
    db!.verseDao.insertVerse(verse);
  }

  Future<void> insertVersesList(List<Verse> verses) async {
    final db = await QuranDatabaseSource.instance.database;
    db!.verseDao.insertVersesList(verses);
  }

  Future<void> updateVerse(Verse verse) async {
    final db = await QuranDatabaseSource.instance.database;
    db!.verseDao.updateVerse(verse);
  }

  Future<void> deleteVerse(Verse verse) async {
    final db = await QuranDatabaseSource.instance.database;
    db!.verseDao.deleteVerse(verse);
  }
}
