import 'package:quran_widget_flutter/data_source/local/local_data_source/recitation_verses_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/recitation_verses_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/recitation_verses.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class RecitationVersesRepository {
  final RecitationVersesLocalDataSource _recitationVersesLocalDataSource =
      RecitationVersesLocalDataSource();
  final RecitationVersesApi _recitationVersesApi = RecitationVersesApi();

  Future<List<RecitationVerses>?> fetchRecitationsVersesList(
      int recitationId, chapterId) async {
    List<RecitationVerses>? recitationsVersesList =
        await _recitationVersesLocalDataSource.fetchRecitationsVersesList();
    if ((recitationsVersesList != null && recitationsVersesList.isNotEmpty)) {
      return recitationsVersesList;
    } else {
      final MyResponse<RecitationVerses> response =
          await _recitationVersesApi.fetchRecitationVersesList();
      if (response.code == Apis.codeSUCCESS) {
        recitationsVersesList = response.data as List<RecitationVerses>;
        _recitationVersesLocalDataSource
            .saveRecitationsVersesList(recitationsVersesList);
      }
      return recitationsVersesList;
    }
  }

  Future<List<RecitationVerses>?> fetchRecitationsVersesChapterList(
    int recitationId,
    int chapterId,
  ) async {
    List<RecitationVerses>? recitationsVersesList =
        await _recitationVersesLocalDataSource
            .fetchRecitationsVersesChapterList(chapterId, recitationId);

    if ((recitationsVersesList != null && recitationsVersesList.isNotEmpty)) {
      return recitationsVersesList;
    } else {
      print('chapterId: $chapterId');
      final MyResponse<RecitationVerses> response =
          await _recitationVersesApi.fetchRecitationVersesList(
        recitationId: recitationId,
        chapterId: chapterId,
      );
      if (response.code == Apis.codeSUCCESS) {
        recitationsVersesList = response.data as List<RecitationVerses>;
        await _recitationVersesLocalDataSource
            .saveRecitationsVersesList(recitationsVersesList);
      }
      return recitationsVersesList;
    }
  }

  Future<RecitationVerses?> fetchRecitationVersesById(
      int recitationId, int recitationVersesId) async {
    RecitationVerses? recitationVerses = await _recitationVersesLocalDataSource
        .fetchRecitationVersesById(recitationVersesId);
    if (recitationVerses != null) {
      return recitationVerses;
    } else {
      final MyResponse<RecitationVerses> response = await _recitationVersesApi
          .fetchRecitationVersesById(recitationId, recitationVersesId);
      if (response.code == Apis.codeSUCCESS) {
        recitationVerses = response.data as RecitationVerses?;
      }
      return recitationVerses;
    }
  }
}
