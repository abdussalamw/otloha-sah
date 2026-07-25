import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';

class ProfilesService {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<List<BaseUser>> getMyFriends({String? search, int? limit}) async {
    Response? response = await _apiBaseHelper.getHTTP(
        '/api/v2/my-profile/friends/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {'page_size': limit ?? 2, 'search': search});
    if (response != null) {
      return (response.data['results'] as List).map(
        (element) {
          return BaseUser.fromMap(element);
        },
      ).toList();
    }
    return [];
  }

  Future<List<Student>> getMyStydents({String? search, int? limit}) async {
    Response? response = await _apiBaseHelper.getHTTP(
        '/api/v2/my-profile/students/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {'page_size': limit ?? 2, 'search': search});
    if (response != null) {
      return (response.data['results'] as List).map(
        (element) {
          return Student.fromMap(element);
        },
      ).toList();
    }
    return [];
  }

  Future<List<Student>> getStudents({String? search, int? limit}) async {
    Response? response = await _apiBaseHelper.getHTTP(
        '/api/v2/users-profiles/students/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {
          'page_size': limit ?? 2,
          'search': search,
        });
    if (response != null) {
      return (response.data['results'] as List).map(
        (element) {
          return Student.fromMap(element);
        },
      ).toList();
    }
    return [];
  }

  Future<List<Teacher>> getTeachers({String? search, int? limit}) async {
    Response? response = await _apiBaseHelper.getHTTP(
        '/api/v2/users-profiles/teachers/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {'page_size': limit ?? 2, 'search': search});
    if (response != null) {
      return (response.data['results'] as List).map(
        (element) {
          return Teacher.fromMap(element);
        },
      ).toList();
    }
    return [];
  }
}
