import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class ChapterApi {
  Future<MyResponse<Chapter>> fetchChaptersList({
    Function(int, int)? onDownloadProgress,
  }) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllCHAPTERS,
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Chapter>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Chapter>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Chapter>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Chapter>> fetchChapterById(int chapterId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllCHAPTERS}$chapterId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Chapter>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Chapter>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Chapter>.init(Apis.codeERROR, null, null);
    }
  }
}
