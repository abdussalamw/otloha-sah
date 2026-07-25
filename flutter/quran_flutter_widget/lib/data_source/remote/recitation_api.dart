import 'package:dio/dio.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/recitation.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class RecitationApi {
  Future<MyResponse<Recitation>> fetchRecitationsList({
    String? qurey,
    int? reciterId,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) async {
    Response? response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllRECITATIONS,
        queryParameters: {
          'q': qurey,
          'narration': narrationId,
          'reciter': reciterId
        },
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Recitation>.fromJson(
          response.data,
          Apis.list,
        );
      } else {
        return MyResponse<Recitation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Recitation>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Recitation>> fetchRecitationById(int recitationId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllRECITATIONS}$recitationId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Recitation>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Recitation>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Recitation>.init(Apis.codeERROR, null, null);
    }
  }
}
