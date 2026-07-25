import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/file_uploader.dart';
import 'package:path/path.dart';
import '../../core/network/api_base_helper.dart';

class RoomServices {
  Future<Response?> roomListing({String roomType = 'recitation'}) async {
    return ApiBaseHelper().getHTTP(
      '/api/v1/chat/$roomType/',
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<Response>? createRoom(int recitation, int userId) async {
    Response response = await ApiBaseHelper().postHTTP(
      '/api/v1/chat/recitation/',
      {
        'recitation': recitation,
        'users': [userId]
      },
      DioTypes.authRequired,
    );
    return response;
  }

  Future<Response?> roomDetails(int id) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/chat/recitation/$id/',
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }

  Future<Response>? deleteRoom(
      {required int id, String roomType = 'recitation'}) async {
    Response response = await ApiBaseHelper().deleteHTTP(
      '/api/v1/chat/$roomType/$id/',
      DioTypes.authRequired,
    );
    return response;
  }

  Future<Response> finishEvaluation(
      {required Map<String, dynamic> data, required int id}) async {
    Response response = await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$id/finish_evaluation/',
      json.encode(data),
      DioTypes.authRequired,
    );
    return response;
  }

  Future<int> uploadRecord(String recordPath) async {
    File record = File(recordPath);

    ChunkedUploader chunkedUploader = ChunkedUploader(ApiBaseHelper().dio);

    Response? response = await chunkedUploader.uploadUsingFilePath(
      filePath: recordPath,
      fileName: basename(recordPath),
      path: '/api/v1/records/chunk-upload/',
      data: {'private': true},
      maxChunkSize: 1024 * 1024,
    );

    // Response response = await ApiBaseHelper().postPhotoHTTP(
    //   '/api/v1/records/chunl-upload',
    //   {
    //     'record': MultipartFile.fromBytes(record.readAsBytesSync(),
    //         filename: record.path.split('/').last)
    //   },
    //   DioTypes.authRequired,
    // );
    print(response?.data['record']);
    return response?.data['id'];
  }
}
