import 'package:quran_widget_flutter/data_source/local/local_data_source/recitation_verses_local_data_source.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class DownloadChapter {
  static Future<ChapterDownload> startDownload({
    required int chapterId,
    required int recitationId,
    required int narrationId,
    required int reciterId,
    Function(double)? retunProgress,
  }) async {
    List<RecitationVerses>? verses = await DataSource.instance
        .fetchRecitationsVersesChapterList(
            recitationId: recitationId, chapterId: chapterId);

    if (verses != null && verses.isNotEmpty) {
      double progress = 0;
      for (RecitationVerses verse in verses) {
        progress = (verse.verseNumber! + 1) / verses.length;
        await FileStorage()
            .download2(
          url: '${Apis.baseUrl}${verse.record!}',
          savePath:
              '/recitation_verse/${verse.recitationId}/${verse.chapterId}/${verse.id}.mp3',
          showDownloadProgress: (p0, p1) {
            if (p0 / p1 == 1) {
              retunProgress!(progress);
            }
          },
        )
            .then((value) {
          verse.recordLocal = value!.path;
          RecitationVersesLocalDataSource().updateRecitationVerses(verse);
        });
      }
    }
    ChapterDownload chapterDownload = ChapterDownload(
      narrationId: narrationId,
      recitationId: recitationId,
      chapterId: chapterId,
      downloaded: true,
      reciterId: reciterId,
    );
    ChapterDownloadLocalDataSource().saveChapterDownloads(chapterDownload);
    return chapterDownload;
  }
}
