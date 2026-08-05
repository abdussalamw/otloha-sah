import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/explanation_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/tafsir_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class TafseerRepository {
  final TafseerApi _tafseerApi = TafseerApi();
  final ExplanationLocalDataSource _tafseerLocal = ExplanationLocalDataSource();

  Future<List<Explanation>?> fetchTafseerList(
      {String? qurey, int? narrationId}) async {
    List<Explanation>? tafseerList = (qurey != null || narrationId != null)
        ? await _tafseerLocal.searchInExplanation(
            narrationId: narrationId, qurey: qurey)
        : await _tafseerLocal.findAllExplanation();

    if ((tafseerList == null || tafseerList.isEmpty) &&
        (QuranCacheRepository.initDataIsSetted == null ||
            !QuranCacheRepository.initDataIsSetted!)) {
      final MyResponse<Explanation> response = await _tafseerApi
          .fetchTafseerList(q: qurey, narrationId: narrationId);
      if (response.code == Apis.codeSUCCESS) {
        tafseerList = response.data;
        await _tafseerLocal.insertExplanationList(tafseerList ?? []);
      }
    }
    return tafseerList;
  }

  Future<Explanation?> fetchTafseerById({required int id}) async {
    Explanation? tafseer = await _tafseerLocal.findExplanationById(id);

    final MyResponse<Explanation> response = await _tafseerApi.fetchTafseer(id);
    if (response.code == Apis.codeSUCCESS) {
      tafseer = response.data;
      _tafseerLocal.insertExplanationList([tafseer!]);
    }
    return tafseer;
  }

  /// verse list tafseer
  Future<List<ExplanationVerse>?> fetchTafseerVersesList({
    required int tafseerId,
    int? chapter,
    int? verseNum,
    int? pageNum,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<ExplanationVerse>? tafseerList = await _tafseerLocal
        .findAllExplanationVerse(tafseerId, chapter: chapter);

    if (tafseerList == null || tafseerList.isEmpty) {
      final MyResponse<ExplanationVerse> response =
          await _tafseerApi.fetchTafseerVersesList(
              tafsieId: tafseerId,
              chapter: chapter,
              verseNum: verseNum,
              pageNum: pageNum,
              onDownloadProgress: onDownloadProgress);
      if (response.code == Apis.codeSUCCESS) {
        tafseerList = response.data;
        await _tafseerLocal.insertExplanationVerseList(tafseerList ?? []);
      }
    }
    return tafseerList;
  }

  Future<ExplanationVerse?> fetchExplanationVerseByVerseId(
      int explanationId, Verse verse) async {
    print(verse.text);
    ExplanationVerse? tafseer =
        await _tafseerLocal.getExplanationVerseByVerseNumberAndChapter(verse.verseNumber!, verse.chapterId!, explanationId);
    if (tafseer == null) {
      final MyResponse<ExplanationVerse> response =
          await _tafseerApi.fetchTafseerVersesList(
        tafsieId: explanationId,
        chapter: verse.chapterId,
      );
      if (response.code == Apis.codeSUCCESS) {
        List<ExplanationVerse>? tafseerList = response.data;
        await _tafseerLocal.insertExplanationVerseList(tafseerList ?? []);
      }
      tafseer = await _tafseerLocal.getExplanationVerseByVerseNumberAndChapter(verse.verseNumber!, verse.chapterId!, explanationId);
    }
    return tafseer;
  }

  Future<ExplanationVerse?> fetchTafseerVersesById(
      {required int tafseetId, required int id}) async {
    ExplanationVerse? tafseer =
        await _tafseerLocal.findExplanationVerseById(id);

    final MyResponse<ExplanationVerse> response =
        await _tafseerApi.fetchTafseerVerse(tafseetId, id);
    if (response.code == Apis.codeSUCCESS) {
      tafseer = response.data;
      _tafseerLocal.insertExplanationVerseList([tafseer!]);
    }
    return tafseer;
  }

  Future<List<ExplanationVerse>?> getSavedChaptersByBookId(int bookId) async {
    return await _tafseerLocal.getSavedChaptersByBookId(bookId);
  }
}
