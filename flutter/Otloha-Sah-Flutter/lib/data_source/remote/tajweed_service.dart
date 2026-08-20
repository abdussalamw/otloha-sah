import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/exam_reservation.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/lesson.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';

class TajweedService {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<Lesson?> getLesson(int id) async {
    Response? response = await _apiBaseHelper.getHTTP(
        '/api/v1/tajweed/lessons/$id/',
        dioTypes: DioTypes.noAuthRequired);

    if (response == null) {
      return null;
    }
    return Lesson.fromMap(response.data);
  }

  Future<ReservedTimeslot> reserveTimeSlot(int id, String examType, int level,
      {String? notes}) async {
    Response? response = await _apiBaseHelper.postHTTP(
      '/api/v1/tajweed/exam-reservations/exam-requests/$id/',
      {
        'exam_type': examType,
        'level': level,
        'notes': notes,
      },
      DioTypes.authRequired,
    );

    return ReservedTimeslot.fromMap(response.data);
  }

  Future<bool> cancelReservation(int reservationId) async {
    try {
      Response? response = await _apiBaseHelper.deleteHTTP(
        '/api/v1/tajweed/exam-reservations/exam-requests/$reservationId/cancel/',
        DioTypes.authRequired,
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Error canceling reservation: $e');
      return false;
    }
  }
}
