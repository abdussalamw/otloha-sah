import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/chapters_page.dart';
import 'package:quran_widget_flutter/model/page.dart';
import 'package:quran_widget_flutter/model/verse.dart';

class PageLocalDataSource {
  Future<List<Page>?> fetchPagesList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.pageDao.findAllPages();
  }

  Future<List<Page>?> fetchPageListByNarrationAndBook(
      {required int narration, required int book}) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.pageDao.findPageListByNarrationAndBook(narration, book);
  }

  Future<List<Page>?> findChapterPage({
    int? bookId,
    int? narrationId,
    int? chapterid,
  }) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.pageDao
        .findChapterPage(narrationId ?? 1, chapterid ?? 1, bookId ?? 1);
  }

  Future<void> savePage(Page page) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.pageDao.insertPage(page);
  }

  Future<List<Verse>?> findAllVersesChapterPage(
      {int? bookId, int? narrationId, int? chapterid, int? pageId}) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.verseDao
        .findAllVersesChapterPage(pageId ?? 0, narrationId ?? 0, bookId ?? 0);
  }

  Future<Page?> fetchPageById(int pageId) async {
    final db = await QuranDatabaseSource.instance.database;
    Page? page = await db?.pageDao.findPageById(pageId);
    return page;
  }

  fetchVerseByPageId(int pageId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db?.verseDao.findAllVersesPage(pageId);
  }

  Future<Verse?>? fetchVerseById(int verseId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db?.verseDao.findVerseById(verseId).first;
  }

  Future<List<ChaptersPage>?>? fetchChapterPageById(int pageId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db?.chaptersPageDao.searchInChapter(pageId);
  }

  fetchChaptersById(int pageId) async {
    final db = await QuranDatabaseSource.instance.database;
    return await db?.verseDao.findAllVersesPage(pageId);
  }

  Future<void> savePagesList(List<Page> pagesList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var page in pagesList) {
      await db?.pageDao.insertPage(page);
      if (page.verses!.isNotEmpty) {
        await db?.verseDao.insertVersesList(page.verses!);
      }
      if (page.glyphs!.isNotEmpty) {
        await db?.glyphDao.insertGlyphs(page.glyphs!);
      }
      if (page.chapters!.isNotEmpty) {
        await db?.chaptersPageDao.insertChaptersPage(page.chapters!);
      }
    }
  }

  Future<void> deletePagesList(List<Page> pagesList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var page in pagesList) {
      await db?.pageDao.deletePage(page);
      if (page.verses != null) {
        for (var verse in page.verses!) {
          await db?.verseDao.insertVerse(verse);
        }
      }
      if (page.glyphs != null) {
        for (var glyph in page.glyphs!) {
          await db?.glyphDao.insertGlyph(glyph);
        }
      }
    }
  }

  updateVerse(Page page) async {
    final db = await QuranDatabaseSource.instance.database;
    db!.pageDao.updatePage(page);
  }
}
