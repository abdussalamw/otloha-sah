import 'package:quran_widget_flutter/data_source/local/local_data_source/part_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/part_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/part.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class PartRepository {
  final PartLocalDataSource _partLocalDataSource = PartLocalDataSource();
  final PartApi _partApi = PartApi();

  Future<List<Part>?> fetchPartsList({
    Function(int, int)? onDownloadProgress,
  }) async {
    List<Part>? partsList = await _partLocalDataSource.fetchPartsList();
    if ((partsList != null && partsList.isNotEmpty)) {
      return partsList;
    } else {
      final MyResponse<Part> response =
          await _partApi.fetchPartsList(onDownloadProgress: onDownloadProgress);
      if (response.code == Apis.codeSUCCESS) {
        partsList = response.data as List<Part>;
        _partLocalDataSource.savePartsList(partsList);
      }
      return partsList;
    }
  }

  Future<Part?> fetchPartById(int partId) async {
    Part? part = await _partLocalDataSource.fetchPartById(partId);
    if (part != null) {
      return part;
    } else {
      final MyResponse<Part> response = await _partApi.fetchPartById(partId);
      if (response.code == Apis.codeSUCCESS) {
        part = response.data as Part?;
      }
      return part;
    }
  }
}
