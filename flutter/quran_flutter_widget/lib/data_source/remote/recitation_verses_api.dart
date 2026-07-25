import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/recitation_verses.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class RecitationVersesApi {
  Future<MyResponse<RecitationVerses>> fetchRecitationVersesList(
      {int? recitationId, int? chapterId}) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllRECITATIONS}verses/',
        queryParameters: {'chapter': chapterId, 'recitation': recitationId});

    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<RecitationVerses>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<RecitationVerses>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<RecitationVerses>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<RecitationVerses>> fetchRecitationVersesById(
      int recitationId, int recitationVersesId) async {
    var response = await DioUtils.request(DioUtils.requestGET,
        '${Apis.fetchAllRECITATIONS}{$recitationId}/verses/$recitationVersesId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<RecitationVerses>.fromJson(
            response.data, Apis.single);
      } else {
        return MyResponse<RecitationVerses>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<RecitationVerses>.init(Apis.codeERROR, null, null);
    }
  }
}
