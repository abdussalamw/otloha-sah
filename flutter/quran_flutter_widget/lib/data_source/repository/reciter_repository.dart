import 'package:quran_widget_flutter/data_source/local/local_data_source/reciter_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/reciter_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/reciter.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class ReciterRepository {
  final ReciterLocalDataSource _reciterLocalDataSource =
      ReciterLocalDataSource();
  final ReciterApi _reciterApi = ReciterApi();

  Future<List<Reciter>?> fetchRecitersList({
    String? qurey,
  }) async {
    List<Reciter>? recitersList = (qurey != null && qurey.isNotEmpty)
        ? await _reciterLocalDataSource.searchRecitersList(qurey)
        : await _reciterLocalDataSource.fetchRecitersList();
    if ((recitersList != null && recitersList.isNotEmpty)) {
      return recitersList;
    } else {
      final MyResponse<Reciter> response =
          await _reciterApi.fetchRecitersList();
      if (response.code == Apis.codeSUCCESS) {
        recitersList = response.data as List<Reciter>;
        await _reciterLocalDataSource.saveRecitersList(recitersList);
      }
      return recitersList;
    }
  }

  Future<Reciter?> fetchReciterById(int reciterId) async {
    print(reciterId);
    Reciter? reciter =
        await _reciterLocalDataSource.fetchReciterById(reciterId);
    print(await _reciterLocalDataSource.fetchRecitersList());
    if (reciter != null) {
      return reciter;
    } else {
      final MyResponse<Reciter> response =
          await _reciterApi.fetchReciterById(reciterId);
      if (response.code == Apis.codeSUCCESS) {
        reciter = response.data as Reciter?;
        await _reciterLocalDataSource.saveRecitersList([reciter!]);
      }
      return reciter;
    }
  }
}
