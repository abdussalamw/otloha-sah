import 'dart:io';

import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/file_uploader.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:path/path.dart';
import 'package:retry_queue_manager/retry_queue_manager.dart';
import '../../core/error/exceptions.dart';
import '../files/file_handler.dart';
import '../local/database/database_repository.dart';
import '../../core/network/api_base_helper.dart';
import '../../core/utils/constant/constants.dart';
import '../models/message_model/general_response.dart';

class UserRecitationApi {
  Future<Recitation>? saveUserReciataion({
    required LocalRecitation userRecitation,
    bool? sendToFavoriteTeacher,
  }) async {
    var map = userRecitation.toMap();
    map['send_to_favorite_teacher'] = sendToFavoriteTeacher ?? false;
    try {
      File file = File(userRecitation.record);
      print(await file.length());

      ChunkedUploader chunkedUploader = ChunkedUploader(ApiBaseHelper().dio);

      Response? response = await chunkedUploader.uploadUsingFilePath(
        filePath: userRecitation.record,
        fileName: basename(userRecitation.record),
        path: '/api/v1/records/chunk-upload/',
        data: {'private': false},
        maxChunkSize: 1024 * 1024,
      );
      //File wave = File(userRecitation.wavePath!);

      map['records'] = [response?.data['id']];

      response = await ApiBaseHelper().postPhotoHTTP(
        '/api/v1/recitations/',
        map,
        DioTypes.authRequired,
      );

      Recitation recitation = Recitation.fromJson(response.data);
      await DatabaseRepository.instance
          .deleteUserRecitation(userRecitation.id!);

      return recitation;
    } on NetworkConnectionException catch (_) {
      await DatabaseRepository.instance
          .deleteUserRecitation(userRecitation.id!);
      map.remove('records');
      await QueueManager(apiHandler: ApiBaseHelper()).addRequest(
          '${Constants.baseUrl}/api/v1/recitations/',
          map,
          {'records': userRecitation.record});

      rethrow;
    }
  }

  Future<Map<String, dynamic>>? getUserReciataions(int page, int userId) async {
    List<Recitation>? userRecitatios;
    bool isLocal = false;

    try {
      Response? response = await ApiBaseHelper().getHTTP(
        '/api/v1/recitations/',
        queryParameters: {'page': page},
        dioTypes: DioTypes.authRequired,
      );

      userRecitatios = (response?.data['results'] as List)
          .map((e) => Recitation.fromJson(e))
          .toList();

      // for (var e in userRecitatios) {
      //   if (e.record != null) {
      //     FileStorage()
      //         .download2(
      //       url: '${Constants.baseUrl}${e.record?.record}',
      //       savePath: '/records/recitations/${e.id}.mp3',
      //       showDownloadProgress: ((p0, p1) {}),
      //     )
      //         .then((value) {
      //       DatabaseRepository.instance
      //           .downloadRecitation(e.copyWith(localRecord: value?.path));
      //     });
      //   }
      // }
    } on NetworkConnectionException catch (_) {
      var data =
          await DatabaseRepository.instance.fetchDownloadedRecitations(userId);

      if (data == null || data.isEmpty) {
        rethrow;
      }
      userRecitatios = data;
      isLocal = true;
    }

    return {
      'recitations': userRecitatios,
      'isLocal': isLocal,
    };
  }

  Future<List<Recitation>?>? getAllRecitations(int page) async {
    Response? response;

    List<Recitation> userRecitatios = [];

    do {
      response = await ApiBaseHelper().getHTTP(
        '/api/v1/recitations/',
        queryParameters: {'page': page},
        dioTypes: DioTypes.authRequired,
      );
      userRecitatios.addAll((response!.data['results'] as List)
          .map((e) => Recitation.fromJson(e))
          .toList());
      page++;
    } while (response.data['next'] != null);

    return userRecitatios;
  }

  Future<List<GeneralResponse>?>? getGeneraBoXMessage() async {
    Response? response = await ApiBaseHelper().getHTTP(
      '${Constants.baseUrl}/api/v1/recitations/?show_in_general=true',
      dioTypes: DioTypes.authRequired,
    );

    List<GeneralResponse>? generalResponses;
    generalResponses = (response!.data['results'] as List)
        .map((data) => GeneralResponse.fromJson(data))
        .toList();

    return generalResponses;
  }

  Future<List<Recitation>>? getUserRecitation(int id) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/users/$id/recitations/',
      dioTypes: DioTypes.authRequired,
    );

    List<Recitation>? recitations = (response!.data as List)
        .map((data) => Recitation.fromJson(data))
        .toList();

    // recitation = Recitation.fromJson(response!.data);

    return recitations;
  }

  Future<List<Recitation>?>? getRecitation(String q) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '${Constants.baseUrl}/api/v1/recitations/?$q=true',
      dioTypes: DioTypes.authRequired,
    );

    List<Recitation>? generalResponses;
    generalResponses = (response!.data['results'] as List)
        .map((data) => Recitation.fromJson(data))
        .toList();

    return generalResponses;
  }

  Future<Recitation?> recitationDetails(int recitationId) async {
    var value = await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/$recitationId',
      dioTypes: DioTypes.authRequired,
    );
    Recitation msg = Recitation.fromJson(value!.data);
    return msg;
  }

  Future<Response?> deleteReply(
      int recitationId, int msgId, int replyId) async {
    return ExceptionHandling.hanleToastException(
      () async => await ApiBaseHelper().deleteHTTP(
        '/api/v1/recitations/$recitationId/messages/$msgId/replies/$replyId/delete/',
        DioTypes.authRequired,
      ),
      'Delete Reply Done',
      true,
    );
  }

  Future<Response> rateTeacherResponse(
      int recitationId, double ownerRate) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$recitationId/rate_teacher_response/',
      {'owner_rate': ownerRate},
      DioTypes.authRequired,
    );
  }

  Future<int> uploadRecord(String recordPath) async {
    File record = File(recordPath);
    Response response = await ApiBaseHelper().postPhotoHTTP(
      '/api/v1/records/',
      {
        'record': MultipartFile.fromBytes(record.readAsBytesSync(),
            filename: record.path.split('/').last)
      },
      DioTypes.authRequired,
    );
    return response.data['id'];
  }

  Future<void> deleteRecord(int id) async {
    await ApiBaseHelper().deleteHTTP(
      '/api/v1/records/$id/',
      DioTypes.authRequired,
    );
  }

  Future<Recitation> updateRecitation(
    int recitationId,
    int oldRecordId,
    String filePath,
  ) async {
    await deleteRecord(oldRecordId);
    int id = await uploadRecord(filePath);

    final response = await ApiBaseHelper().putHTTP(
      '/api/v1/recitations/$recitationId/',
      {
        'records': [id],
      },
      DioTypes.authRequired,
    );
    return Recitation.fromJson(response.data);
  }
}
