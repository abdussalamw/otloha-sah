import 'package:dio/dio.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

import '../../model/apis_response/my_response.dart';

class TajweedApi {
  Future<MyResponse<TajweedBook>> fetchTajweedBookList(
      String? qurey, int? narationId) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllTAJWEED,
        queryParameters: {'q': qurey, 'narration': narationId});
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedBook>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedBook>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedBook>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedBook>> fetchTajweedBookById(int id) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAJWEED}$id/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedBook>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<TajweedBook>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedBook>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedCharactersList(
      int bookId) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAJWEED}$bookId/characters/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedCharactersByVerseList(
      int bookId, int verseId) async {
    Response? response = await DioUtils.request(DioUtils.requestGET,
        '${Apis.fetchAllTAJWEED}$bookId/characters/by/verses/$verseId/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedCharactersByChapterList(
    int bookId,
    int chapterId, {
    Function(int, int)? onDownloadProgress,
  }) async {
    Response? response = await DioUtils.request(
      DioUtils.requestGET,
      '${Apis.fetchAllTAJWEED}$bookId/characters/by/chapters/$chapterId/',
      onDownloadProgress: onDownloadProgress,
    );
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedWordsByWordList(
      int bookId, int wordId) async {
    Response? response = await DioUtils.request(DioUtils.requestGET,
        '${Apis.fetchAllTAJWEED}$bookId/characters/by/words/$wordId/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedCharactersById(
      int bookId, int id) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAJWEED}$bookId/characters/$id/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(
            response.data, Apis.single);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TajweedCharacters>> fetchTajweedWord() async {
    Response? response =
        await DioUtils.request(DioUtils.requestGET, Apis.fetchAllTAJWEED);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TajweedCharacters>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TajweedCharacters>.init(Apis.codeERROR, null, null);
    }
  }
}
