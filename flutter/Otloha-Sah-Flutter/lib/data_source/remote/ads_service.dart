import 'dart:convert';

import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';

import '../cache_helper.dart';
import '../models/ads/ads_model.dart';

class AdsApi {
  static final AdsApi _adsApi = AdsApi._internal();

  factory AdsApi() {
    return _adsApi;
  }

  AdsApi._internal();

  List<AdsModel> ads = [];

  Future<List<AdsModel>> getAds() async {
    try {
      if (ads.isEmpty) {
        final response = await ApiBaseHelper()
            .getHTTP('/api/v1/ads/', dioTypes: DioTypes.noAuthRequired);
        ads =
            (response!.data as List).map((e) => AdsModel.fromJson(e)).toList();
        await CacheHelper.saveData(
            key: 'ads', value: json.encode(response.data));
      }
    } catch (_) {
      print(CacheHelper.getData(key: 'ads'));
      final data = json.decode(CacheHelper.getData(key: 'ads') ?? '[]');
      ads = (data as List).map((e) => AdsModel.fromJson(e)).toList();
    }
    return ads;
  }
}
