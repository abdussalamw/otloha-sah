import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';

@dao
abstract class ChapterDownloadDao {
  @Query(
      'SELECT * FROM ChapterDownload WHERE narrationId = :narrationId AND recitationId = :recitationId')
  Future<List<ChapterDownload>> findAllChapterDownloads(
      int narrationId, int recitationId);

  @Query('SELECT * FROM ChapterDownload WHERE id = :id')
  Future<ChapterDownload?> findChapterDownloadById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertChapterDownload(ChapterDownload chapterDownload);

  @update
  Future<void> updateChapterDownload(ChapterDownload chapterDownload);

  @delete
  Future<void> deleteChapterDownload(ChapterDownload chapterDownload);
}
