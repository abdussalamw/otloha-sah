import 'dart:convert';

import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class PageApi {
  Future<MyResponse<Page>> fetchAllPages() async {
    var response = await DioUtils.request(
      DioUtils.requestGET,
      Apis.fetchAllPAGES,
    );
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Page>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Page>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Page>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Page>> fetchPagesList({
    int? bookId,
    int? narrationId,
  }) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, Apis.fetchAllPAGES,
        queryParameters: {
          'narration': narrationId,
          'book': bookId,
        });
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Page>.fromJson(response.data, Apis.list);
      } else {
        return MyResponse<Page>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Page>.init(Apis.codeERROR, null, null);
    }
  }

  Future<MyResponse<Page>> fetchPageById(int pageId) async {
    var response = await DioUtils.request(
        DioUtils.requestGET, '${Apis.fetchAllPAGES}$pageId');
    if (response != null) {
      if (response.statusCode == 200) {
        return MyResponse<Page>.fromJson(response.data, Apis.single);
      } else {
        return MyResponse<Page>.init(Apis.codeERROR, null, null);
      }
    } else {
      return MyResponse<Page>.init(Apis.codeERROR, null, null);
    }
  }

  fetchPagesListDown({int? bookId, int? narrationId}) async {
    dynamic _fromString;
    await FileStorage()
        .download2(
            url:
                Apis.fetchAllPAGES + '?book=1&narration=1&chapter=2&download=1',
            savePath: '/saveToFetch.json',
            showDownloadProgress: (v, t) {
              // print('precess  ${v / t * 100} %');
            })
        .then(
      (value) async {
        print('file down path ${value!.path}');
        final file = value;
        // Read the file
        var response = await file.readAsString();

        _fromString = jsonDecode(response);
        print('file down path $_fromString');
      },
    );

    if (_fromString != null) {
      print('start Return 1');
      return MyResponse<Page>.fromJson(_fromString, Apis.list);
    } else {
      print('start Return 2');
      return MyResponse<Page>.init(Apis.codeERROR, null, null);
    }
  }
}
