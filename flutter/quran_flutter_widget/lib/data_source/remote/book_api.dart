import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/book.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

class BookApi {
  Future<MyResponse<Book>> fetchBooksList({
    String? qurey,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllBOOKS,
        queryParameters: {'q': qurey, 'narration': narrationId},
        onDownloadProgress: onDownloadProgress);
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Book>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Book>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Book>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Book>> fetchBookById(int bookId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllBOOKS}$bookId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Book>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Book>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Book>.init(Apis.codeERROR, null, null);
    }
  }
}
