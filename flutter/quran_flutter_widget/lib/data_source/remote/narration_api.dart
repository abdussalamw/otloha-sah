import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class NarrationApi {
  Future<MyResponse<Narration>> fetchNarrationsList({
    String? qurey,
    Function(int, int)? onDownloadProgress,
  }) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllNARRATIONS,
        queryParameters: {'q': qurey}, onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Narration>.fromJson(response.data, Apis.list,
            code: response.statusCode);
      } else {
        return MyResponse<Narration>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Narration>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Narration>> fetchNarrationById(int narrationId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllNARRATIONS}$narrationId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Narration>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Narration>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Narration>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Verse>> fetchWordsList({
    String? qurey,
    int? chapterNumber,
    Function(int, int)? onDownloadProgress,
  }) async {
    int narrationId = QuranCacheRepository.narrationSelectedId ?? 1;
    var narrationName = QuranCacheRepository.narrationSelectedName;

    // var tempDir = await getTemporaryDirectory();
    // String fullPath = tempDir.path + '/1.json';
    // var response = await DioUtils.request(
    //   DioUtils.requestDownload,
    //   '${Apis.fetchAllNARRATIONS}$narrationId/verses/',
    //   savePath: fullPath,
    //   queryParameters: {'q': qurey, 'chapter_number': chapterNumber},
    //   onDownloadProgress: onDownloadProgress,
    // );
    String data = await rootBundle.loadString('assets/$narrationId.json');
    // print(response?.data);
    // File file = File(fullPath);

    // final contents = await file.readAsString();

    await CacheHelper.saveData(key: narrationName, value: data);
    return MyResponse<Verse>.fromJson(jsonDecode(data), Apis.list);
    // if (response != null) {
    //   if (response.statusCode == 200) {
    //   } else {
    //     return MyResponse<Verse>.init(Apis.codeERROR, null, null);
    //   }
    // } else {
    //   return MyResponse<Verse>.init(Apis.codeERROR, null, null);
    // }
  }
}
