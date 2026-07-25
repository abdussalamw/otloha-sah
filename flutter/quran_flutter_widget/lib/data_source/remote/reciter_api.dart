import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/reciter.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class ReciterApi {
  Future<MyResponse<Reciter>> fetchRecitersList() async {
    var response =
        await DioUtils.request(DioUtils.requestGET, Apis.fetchAllRECITERS);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Reciter>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Reciter>> fetchReciterById(int reciterId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllRECITERS}$reciterId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Reciter>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Reciter>.init(Apis.codeERROR, null, null);
    }
  }
}
