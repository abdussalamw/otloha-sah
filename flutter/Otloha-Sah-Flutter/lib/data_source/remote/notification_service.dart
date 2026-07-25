import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/data_source/cache_helper.dart';
import '../../core/network/api_base_helper.dart';

class NotificationsService {
  Future<Response<dynamic>?>? notificationsListing(int page,
      {bool? markUnseen = false}) async {
    final response = await ApiBaseHelper().getHTTP(
      '/api/v1/notifications/?page=$page&mark_unseen=$markUnseen',
      dioTypes: DioTypes.authRequired,
    );
    CacheHelper.saveData(
        key: 'notifications', value: json.encode(response?.data['results']));
    return response!;
  }

  Future<void> markAsRead(int id) async {
    await ApiBaseHelper().getHTTP(
      '/api/v1/notifications/$id/mark_as_read/',
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<void> markAllAsRead() async {
    await ApiBaseHelper().postHTTP(
      '/api/v1/notifications/mark_as_read/',
      {},
      DioTypes.authRequired,
    );
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    await ApiBaseHelper().postHTTP(
      '/api/v1/notifications/update_settings/',
      data,
      DioTypes.authRequired,
    );
  }

  Future<Map<String, dynamic>> getUnseenCount() async {
    final res = await ApiBaseHelper().getHTTP(
      '/api/v1/get-updates/',
      dioTypes: DioTypes.authRequired,
    );
    return res?.data;
  }
}
