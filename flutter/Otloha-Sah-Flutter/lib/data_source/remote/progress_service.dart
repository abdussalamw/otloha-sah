import 'package:dio/dio.dart';
import '../../core/network/api_base_helper.dart';
import '../models/progress/progress_model.dart';
import '../models/progress/statistics_model.dart';

class ProgressService {
  Future<StatisticsModel> getStatistics(int narrationId) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/progress/$narrationId/statistics/',
      dioTypes: DioTypes.authRequired,
    );
    return StatisticsModel.fromMap(response!.data);
  }

  Future<ProgressModel> getProgress(int narrationId, int chapterId) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/progress/$narrationId/recitations/$chapterId/',
      dioTypes: DioTypes.authRequired,
    );
    return ProgressModel.fromMap(response!.data);
  }
}
