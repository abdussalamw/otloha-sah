import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/recitation.dart';

class RecitationLocalDataSource {
  Future<List<Recitation>?> fetchRecitationsList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationDao.findAllRecitations();
  }

  Future<List<Recitation>?> fetchRecitationsListByNarration(
      int narrationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationDao.findRecitationsByNarration(narrationId);
  }

  Future<List<Recitation>?> fetchRecitationsListQurey({
    String? qurey,
    int? reciterId,
    int? narrationId,
  }) async {
    final db = await QuranDatabaseSource.instance.database;
    if (narrationId != null && reciterId != null) {
      return db?.recitationDao.findRecitations(narrationId, reciterId);
    }
    return db?.recitationDao.findAllRecitations();
  }

  Future<Recitation?> fetchRecitationById(int recitationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.recitationDao.findRecitationById(recitationId).first;
  }

  Future<void> saveRecitationsList(List<Recitation> recitationsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var recitation in recitationsList) {
      await db?.recitationDao.insertRecitation(recitation);
    }
  }

  Future<void> deleteRecitationsList(List<Recitation> recitationsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var recitation in recitationsList) {
      await db?.recitationDao.deleteRecitation(recitation);
    }
  }
}
