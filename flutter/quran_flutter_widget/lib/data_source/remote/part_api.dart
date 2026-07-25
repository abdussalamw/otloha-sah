import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/part.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class PartApi {
  Future<MyResponse<Part>> fetchPartsList({
    Function(int, int)? onDownloadProgress,
  }) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllPARTS,
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Part>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Part>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Part>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Part>> fetchPartById(int partId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllPARTS}$partId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Part>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Part>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Part>.init(Apis.codeERROR, null, null);
    }
  }
}
