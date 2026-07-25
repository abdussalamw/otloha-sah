import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/recitation_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/recitation_api.dart';
import 'package:quran_widget_flutter/data_source/repository/reciter_repository.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/recitation.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class RecitationRepository {
  final RecitationLocalDataSource _recitationLocalDataSource =
      RecitationLocalDataSource();
  final RecitationApi _recitationApi = RecitationApi();
  final ReciterRepository _reciterRepository = ReciterRepository();

  Future<List<Recitation>?> fetchRecitationsList({
    String? qurey,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<Recitation> recitationsList = [];
    recitationsList =
        await _recitationLocalDataSource.fetchRecitationsListByNarration(
                QuranCacheRepository.narrationSelectedId ?? 1) ??
            [];
    if ((recitationsList.isEmpty)) {
      final MyResponse<Recitation> response = await _recitationApi
          .fetchRecitationsList(onDownloadProgress: onDownloadProgress);
      if (response.code == Apis.codeSUCCESS) {
        recitationsList = (response.data as List<Recitation>)
            .where((element) =>
                element.narrationId == (QuranCacheRepository.narrationSelectedId ?? 1))
            .toList();
        await _recitationLocalDataSource.saveRecitationsList(response.data as List<Recitation>);
      }
    }

    for (var i = 0; i < recitationsList.length; i++) {
      recitationsList[i].reciter =
          await _reciterRepository.fetchReciterById(recitationsList[i].id!);
    }
    return recitationsList;
  }

  Future<Recitation?> fetchRecitationById(int recitationId) async {
    Recitation? recitation =
        await _recitationLocalDataSource.fetchRecitationById(recitationId);
    if (recitation != null) {
      return recitation;
    } else {
      final MyResponse<Recitation> response =
          await _recitationApi.fetchRecitationById(recitationId);
      if (response.code == Apis.codeSUCCESS) {
        recitation = response.data as Recitation?;
      }
      return recitation;
    }
  }
}
