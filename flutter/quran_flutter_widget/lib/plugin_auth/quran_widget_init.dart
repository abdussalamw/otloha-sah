import 'dart:async';

import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class QuranWidgetInit {
  static Future<void> init({String? baseUrl}) async {
    if (baseUrl != null) {
      Apis.baseUrl = baseUrl;
    }

    await CacheHelper.init();
  }
}
