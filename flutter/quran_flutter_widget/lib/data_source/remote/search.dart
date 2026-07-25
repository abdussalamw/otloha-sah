// Future<MyResponse<Reciter>> fetchRecitersList() async {
//   var response =
//       await DioUtils.request(DioUtils.requestGET, Apis.fetchAllRECITERS);
//   if (response != null) {
//     if (response.statusCode == 200) {
//       return MyResponse<Reciter>.fromJson(response.data, Apis.list);
//     } else {
//       return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
//     }
//   } else {
//     return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
//   }
// }

import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/search.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class SearchApi {
  Future<MyResponse<Search>> fetchSearchList(String query) async {
    int narrationId = QuranCacheRepository.narrationSelectedId;
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllSEARCH}$narrationId/?q=$query');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Search>.fromJson(response.data, Apis.list, code: 200);
      } else {
        return MyResponse<Search>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Search>.init(Apis.codeERROR, null, null);
    }
  }
}
