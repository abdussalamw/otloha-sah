import 'package:dio/dio.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

import '../../model/apis_response/my_response.dart';

class TafseerApi {
  Future<MyResponse<Explanation>> fetchTafseerList(
      {int? narrationId, String? q}) async {
    Response? response = await DioUtils.request(
      DioUtils.requestGET,
      Apis.fetchAllTAFSEER,
      queryParameters: {
        'narration': narrationId,
        ''
        'q': q,
      },
    );
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Explanation>.fromJson(
          response.data,
          Apis.list,
        );
      } else {
        return MyResponse<Explanation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Explanation>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Explanation>> fetchTafseer(int id) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAFSEER}$id/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Explanation>.fromJson(
          response.data,
          Apis.single,
        );
      } else {
        return MyResponse<Explanation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Explanation>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<ExplanationVerse>> fetchTafseerVersesList({
    required int tafsieId,
    int? chapter,
    int? verseNum,
    int? pageNum,
    Function(int, int)? onDownloadProgress,
  }) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAFSEER}$tafsieId/verses/',
        queryParameters: {
          'chapter': chapter,
          'verse_number': verseNum,
          'page_number': pageNum,
        },
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<ExplanationVerse>.fromJson(
          response.data,
          Apis.list,
        );
      } else {
        return MyResponse<ExplanationVerse>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<ExplanationVerse>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<ExplanationVerse>> fetchTafseerVerse(
      int tafsieId, int id) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTAFSEER}$tafsieId/verses/$id');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<ExplanationVerse>.fromJson(
          response.data,
          Apis.single,
        );
      } else {
        return MyResponse<ExplanationVerse>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<ExplanationVerse>.init(Apis.codeERROR, null, null);
    }
  }
}
