import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';

class ChapterDownloadLocalDataSource {
  Future<List<ChapterDownload>?> fetchChapterDownloadsList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.chapterDownloadDao.findAllChapterDownloads(
      QuranCacheRepository.narrationSelectedId,
      QuranCacheRepository.selectedRecitationId,
    );
  }

  Future<ChapterDownload?> fetchChapterDownloadsById(int id) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.chapterDownloadDao.findChapterDownloadById(id);
  }

  Future<void> saveChapterDownloads(ChapterDownload chapterDownload) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.chapterDownloadDao.insertChapterDownload(chapterDownload);
  }

  Future<void> updateChapterDownloads(ChapterDownload chapterDownload) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.chapterDownloadDao.updateChapterDownload(chapterDownload);
  }

  Future<void> deleteChapterDownloads(ChapterDownload chapterDownload) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.chapterDownloadDao.deleteChapterDownload(chapterDownload);
  }
}
