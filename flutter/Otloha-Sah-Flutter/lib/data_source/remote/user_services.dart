import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/details_models/teacher_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/models/user/details_models/student_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../core/network/api_base_helper.dart';

class UserServices {
  Future<Response> changePassword(
      {required oldPassword,
      required newPassword,
      required confirmPassword}) async {
    return await ApiBaseHelper().putHTTP(
      '/api/v1/change_password/',
      {
        'old_password': oldPassword,
        'new_password1': newPassword,
        'new_password2': confirmPassword,
      },
      DioTypes.authRequired,
    );
  }

  Future<Response> updateEmail({required email, required password}) async {
    return await ApiBaseHelper().putHTTP(
      '/api/v1/profile/change-email/',
      {
        'email': email,
        'password': password,
      },
      DioTypes.authRequired,
    );
  }

  Future<Response> updatePhone({required phone, required password}) async {
    return await ApiBaseHelper().putHTTP(
      '/api/v1/profile/change-phone/',
      {'new_phone': phone, 'password': password},
      DioTypes.authRequired,
    );
  }

  Future<Response> updateProfile({
    required String username,
    required String gender,
    String? firstName,
    String? lastName,
    String? bio,
    required String birthdate,
    MultipartFile? image,
    String? email,
    String? phone,
  }) async {
    var data = {
      'username': username,
      'gender': gender,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'birthdate': birthdate,
    };
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;

    FormData formData = FormData.fromMap(data);

    if (image != null) formData.files.add(MapEntry('image', image));
    return await ApiBaseHelper().putHTTP(
      '/api/v1/profile/update-profile/',
      formData,
      DioTypes.authRequired,
    );
  }

  Future<Response> registerAsATeacher(data) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/users/register-as-a-teacher/',
      data,
      DioTypes.authRequired,
    );
  }

  Future<Response> markAsFavTeacher({required int? id}) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/users/mark-as-fav-teacher/',
      {'teacher': id},
      DioTypes.authRequired,
    );
  }

  Future<User> myProfile() async {
    var response = await ApiBaseHelper().getHTTP(
      '/api/v1/profile/',
      dioTypes: DioTypes.authRequired,
    );
    return User.fromJson(response!.data);
  }

  Future<BaseProfile> myProfileV2() async {
    var response = await ApiBaseHelper().getHTTP(
      '/api/v2/my-profile/',
      dioTypes: DioTypes.authRequired,
    );
    return BaseProfile.fromJson(response!.data);
  }

  Future<User> userProfile(int id) async {
    var response = await ApiBaseHelper().getHTTP(
      '/api/v1/users/$id/',
      dioTypes: DioTypes.authRequired,
    );
    return User.fromJson(response!.data);
  }

  Future<StudentProfile> studentProfile(int id) async {
    var response = await ApiBaseHelper().getHTTP(
      '/api/v2/users-profiles/$id/',
      dioTypes: DioTypes.authRequired,
    );
    return StudentProfile.fromMap(response!.data);
  }

  Future<TeacherProfile> teacherProfile(int id) async {
    var response = await ApiBaseHelper().getHTTP(
      '/api/v2/users-profiles/$id/',
      dioTypes: DioTypes.authRequired,
    );
    return TeacherProfile.fromMap(response!.data);
  }

  Future<List<User>?>? getTeacher(int page) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/users/teachers/',
      queryParameters: {'page': page},
      dioTypes: DioTypes.authRequired,
    );

    List<User>? teachers;

    teachers = (response!.data['results'] as List)
        .map((e) => User.fromJson(e))
        .toList();

    return teachers;
  }

  Future<List<User>?> getStudents(int page) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/users/students/',
      queryParameters: {'page': page},
      dioTypes: DioTypes.authRequired,
    );

    List<User>? teachers;

    teachers = (response!.data['results'] as List)
        .map((e) => User.fromJson(e))
        .toList();

    return teachers;
  }

  Future<Response?>? sendMessage(int id, List<int> users) async {
    var response = await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$id/messages/send/',
      {'users': users},
      DioTypes.authRequired,
    );
    return response;
  }

  Future<void> removeFavoriteTeacher() async {
    await ApiBaseHelper().deleteHTTP(
      '/api/v2/my-profile/remove-favorite-teacher/',
      DioTypes.authRequired,
    );
  }

  Future<Response> unfriend(int id) async {
    return await ApiBaseHelper().deleteHTTP(
      '/api/v2/users-profiles/unfriend/$id/',
      DioTypes.authRequired,
    );
  }
}
