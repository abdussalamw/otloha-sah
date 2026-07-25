import 'package:quran_widget_flutter/data_source/local/local_data_source/translation_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/translation_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class TranslationRepository {
  final TranslationApi _translationApi = TranslationApi();
  final TranslationLocalDataSource _translationLocal =
      TranslationLocalDataSource();

  Future<List<Translation>?> fetchTranslationList({
    String? qurey,
  }) async {
    List<Translation> tranList =
        await _translationLocal.findAllTranslation() ?? [];

    if (tranList.isEmpty &&
        (QuranCacheRepository.initDataIsSetted == null ||
            !QuranCacheRepository.initDataIsSetted!)) {
      final MyResponse<Translation> response =
          await _translationApi.fetchTranslationList();
      if (response.code == Apis.codeSUCCESS) {
        tranList = response.data;
        await _translationLocal.insertTranslationList(tranList);
      }
    }
    return tranList;
  }

  Future<Translation?> fetchTranslationById(
    int id, {
    Function(int, int)? onDownloadProgress,
  }) async {
    Translation? tran = await _translationLocal.findTranslationById(id);

    final MyResponse<Translation> response = await _translationApi
        .fetchTranslationById(id, onDownloadProgress: onDownloadProgress);
    if (response.code == Apis.codeSUCCESS) {
      tran = response.data;
      await _translationLocal.insertTranslation(tran!);
    }
    return tran;
  }

  Future<List<TranslationVerse>?> fetchTranslationVerseList({
    String? qurey,
    required int tranId,
    int? chapter,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<TranslationVerse>? tranList =
        await _translationLocal.findAllTranslationVerses(tranId);

    final MyResponse<TranslationVerse> response =
        await _translationApi.fetchTranslationVersesList(tranId,
            chapter: chapter, onDownloadProgress: onDownloadProgress);
    if (response.code == Apis.codeSUCCESS) {
      tranList = response.data;
      await _translationLocal.insertTranslationVerseList(tranList ?? []);
    }
    return tranList;
  }

  Future<TranslationVerse?> fetchTranslationVerseById(
      {required int tranId, required int id}) async {
    TranslationVerse? tran =
        await _translationLocal.findTranslationVerseById(id);

    final MyResponse<TranslationVerse> response =
        await _translationApi.fetchTranslationVerseById(tranId, id);
    if (response.code == Apis.codeSUCCESS) {
      tran = response.data;
      await _translationLocal.insertTranslationVerse(tran!);
    }
    return tran;
  }

  Future<TranslationVerse?> fetchTranslationVerseByVerseId(Verse verse) async {
    TranslationVerse? translation =
        await _translationLocal.findTranslationVerseByVerseId(
      QuranCacheRepository.quranTranslationSelectedId ?? 1,
      verse.verseNumber!,
      verse.chapterNumber!,
    );
    if (translation == null) {
      final MyResponse<TranslationVerse> response =
          await _translationApi.fetchTranslationVersesList(
        QuranCacheRepository.quranTranslationSelectedId ?? 1,
        chapter: verse.chapterId,
      );
      if (response.code == Apis.codeSUCCESS) {
        List<TranslationVerse>? tranList = response.data;
        await _translationLocal.insertTranslationVerseList(tranList ?? []);
        translation = await _translationLocal.findTranslationVerseByVerseId(
          QuranCacheRepository.quranTranslationSelectedId ?? 1,
          verse.verseNumber!,
          verse.chapterNumber!,
        );
        print('object');
        print(tranList);
      }
    }
    return translation;
  }

  Future<List<TranslationVerse>?> getSavedChaptersByBookId(int bookId) async {
    return await _translationLocal.getSavedChaptersByBookId(bookId);
  }
}
