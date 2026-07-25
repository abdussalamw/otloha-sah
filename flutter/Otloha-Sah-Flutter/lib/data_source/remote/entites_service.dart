import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';

class EntitiesServices {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<List<Entity>> getEntities({int? limit = 5}) async {
    Response? response = await _apiBaseHelper.getHTTP('/api/v1/entities/',
        dioTypes: DioTypes.authRequired, queryParameters: {'limit': limit});
    if (response != null) {
      return (response.data['results'] as List)
          .map((e) => Entity.fromMap(e))
          .toList();
    }
    return [];
  }
}
