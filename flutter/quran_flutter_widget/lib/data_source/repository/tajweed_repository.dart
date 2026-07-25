import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/tajweed_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/tajweed_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class TajweedRepository {
  final TajweedApi _tajweedApi = TajweedApi();
  final TajweedLocalDataSource _tajweedLocalDataSource =
      TajweedLocalDataSource();

  Future<List<TajweedBook>?> fetchTajweedBooksList({
    String? qurey,
    int? narrationId,
  }) async {
    List<TajweedBook> tajweedList = [];

    tajweedList = await _tajweedLocalDataSource.findAllTajweed(
        qurey: qurey, narrationId: narrationId);

    if (tajweedList.isEmpty &&
        (QuranCacheRepository.initDataIsSetted == null ||
            !QuranCacheRepository.initDataIsSetted!)) {
      final MyResponse<TajweedBook> response =
          await _tajweedApi.fetchTajweedBookList(qurey, narrationId);
      if (response.code == Apis.codeSUCCESS) {
        tajweedList = response.data;
        await _tajweedLocalDataSource.insertAllTajweed(tajweedList);
      }
    }
    return tajweedList;
  }

  Future<TajweedBook?> fetchTajweedBookById({
    required int id,
  }) async {
    TajweedBook? tajweed = await _tajweedLocalDataSource.findTajweedById(id);

    if (tajweed != null) {
      final MyResponse<TajweedBook> response =
          await _tajweedApi.fetchTajweedBookById(id);
      if (response.code == Apis.codeSUCCESS) {
        tajweed = response.data;
        await _tajweedLocalDataSource.insertTajweed(tajweed!);
      }
    }
    return tajweed;
  }

  Future<List<TajweedCharacters>?> fetchTajweedCharactersList(
      {required int bookId}) async {
    List<TajweedCharacters>? tajweedList =
        await _tajweedLocalDataSource.findAllTajweedCharacters(bookId);

    if (tajweedList != null && tajweedList.isEmpty) {
      final MyResponse<TajweedCharacters> response =
          await _tajweedApi.fetchTajweedCharactersList(bookId);
      if (response.code == Apis.codeSUCCESS) {
        tajweedList = response.data;
        await _tajweedLocalDataSource.insertAllTajweedCharacters(tajweedList!);
      }
    }

    return tajweedList;
  }

  Future<List<TajweedCharacters>?> fetchTajweedCharactersByVerseList(
      {required int verseId}) async {
    List<TajweedCharacters>? tajweedList = await _tajweedLocalDataSource
        .findAllTajweedCharacters(QuranCacheRepository.selectedTajweedId ?? 1,
            verse: verseId);

    if (tajweedList == null || tajweedList.isEmpty) {
      final MyResponse<TajweedCharacters> response =
          await _tajweedApi.fetchTajweedCharactersByVerseList(
              QuranCacheRepository.selectedTajweedId ?? 1, verseId);
      if (response.code == Apis.codeSUCCESS) {
        tajweedList = response.data;
        await _tajweedLocalDataSource.insertAllTajweedCharacters(tajweedList!);
      }
    }

    return tajweedList;
  }

  Future<List<TajweedCharacters>?> fetchTajweedCharactersByChapterList({
    required int bookId,
    required int chapterId,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<TajweedCharacters>? tajweedList = await _tajweedLocalDataSource
        .findAllTajweedCharacters(bookId, chapter: chapterId);

    if (tajweedList != null && tajweedList.isEmpty) {
      final MyResponse<TajweedCharacters> response = await _tajweedApi
          .fetchTajweedCharactersByChapterList(bookId, chapterId,
              onDownloadProgress: onDownloadProgress);
      if (response.code == Apis.codeSUCCESS) {
        tajweedList = response.data;
        await _tajweedLocalDataSource.insertAllTajweedCharacters(tajweedList!);
      }
    }

    return tajweedList;
  }

  Future<List<TajweedCharacters>?> fetchTajweedWordsByWordList(
      {required int bookId, required int wordId}) async {
    List<TajweedCharacters>? tajweedList = await _tajweedLocalDataSource
        .findAllTajweedCharacters(bookId, word: wordId);

    if (tajweedList != null && tajweedList.isEmpty) {
      final MyResponse<TajweedCharacters> response =
          await _tajweedApi.fetchTajweedWordsByWordList(bookId, wordId);
      if (response.code == Apis.codeSUCCESS) {
        tajweedList = response.data;
        await _tajweedLocalDataSource.insertAllTajweedCharacters(tajweedList!);
      }
    }

    return tajweedList;
  }

  Future<TajweedCharacters?> fetchTajweedCharactersById({
    required int bookId,
    required int id,
  }) async {
    TajweedCharacters? tajweed =
        await _tajweedLocalDataSource.findTajweedWordById(id);

    if (tajweed != null) {
      final MyResponse<TajweedCharacters> response =
          await _tajweedApi.fetchTajweedCharactersById(bookId, id);
      if (response.code == Apis.codeSUCCESS) {
        tajweed = response.data;
        await _tajweedLocalDataSource.insertTajweedWord(tajweed!);
      }
    }
    return tajweed;
  }

  Future<List<TajweedCharacters>> getSavedChaptersByBookId(int bookId) async {
    return await _tajweedLocalDataSource.getSavedChaptersByBookId(bookId);
  }
}
