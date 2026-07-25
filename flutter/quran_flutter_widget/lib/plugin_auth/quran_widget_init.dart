import 'dart:async';
import 'dart:convert' show base64, utf8;

import 'package:dio/dio.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/plugin_auth/auth_plugin_model.dart';

class QuranWidgetInit {
  static Dio dio = Dio();

  static Future<void> init(
      {required String clientId, required String clientSecret}) async {
    Apis.clientId = clientId;
    Apis.clientSecret = clientSecret;

    String auth = '$clientId:$clientSecret';
    String encoded = base64.encode(utf8.encode(auth));

    try {
      dio = Dio(BaseOptions(
        baseUrl: Apis.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Authorization': 'Basic $encoded',
          'Cache-Control': 'no-cache',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ));

      Response response =
          await dio.post('/o/token/', data: 'grant_type=client_credentials');

      var val = AuthPluginModel.fromJson(response.data);
      Apis.authorization = '${val.tokenType} ${val.accessToken}';
    } catch (e) {
      // throw NetworkConnectionExceptionOnTocken();
    }

    await CacheHelper.init();
  }
}
