import 'package:dio/dio.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

import '../../model/apis_response/my_response.dart';

class TranslationApi {
  Future<MyResponse<Translation>> fetchTranslationList() async {
    Response? response =
        await DioUtils.request(DioUtils.requestGET, Apis.fetchAllTRANSLATION);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Translation>.fromJson(
          response.data,
          Apis.list,
        );
      } else {
        return MyResponse<Translation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Translation>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Translation>> fetchTranslationById(
    int id, {
    Function(int, int)? onDownloadProgress,
  }) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTRANSLATION}$id',
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Translation>.fromJson(
          response.data,
          Apis.single,
        );
      } else {
        return MyResponse<Translation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Translation>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TranslationVerse>> fetchTranslationVersesList(
    int tranId, {
    int? chapter,
    Function(int, int)? onDownloadProgress,
  }) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTRANSLATION}$tranId/verses/',
        queryParameters: {'chapter': chapter},
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TranslationVerse>.fromJson(
          response.data,
          Apis.list,
        );
      } else {
        return MyResponse<TranslationVerse>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TranslationVerse>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<TranslationVerse>> fetchTranslationVerseById(
      int tranId, int id) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllTRANSLATION}$tranId/verses/$id/');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<TranslationVerse>.fromJson(
          response.data,
          Apis.single,
        );
      } else {
        return MyResponse<TranslationVerse>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<TranslationVerse>.init(Apis.codeERROR, null, null);
    }
  }
}
