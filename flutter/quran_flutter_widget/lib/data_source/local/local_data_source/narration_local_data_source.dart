import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/narration.dart';

class NarrationLocalDataSource {
  Future<List<Narration>?> fetchNarrationsList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.narrationDao.findAllNarrations();
  }

  Future<void> insertNarrations(Narration narration) async {
    final db = await QuranDatabaseSource.instance.database;
    db?.narrationDao.insertNarration(narration);
  }

  Future<List<Narration>?> searchInNarration(String qurey) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.narrationDao.searchInNarration('%$qurey%');
  }

  Future<Narration?> fetchNarrationById(int narrationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.narrationDao.findNarrationById(narrationId).first;
  }

  Future<void> saveNarrationsList(List<Narration> narrationsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (Narration narration in narrationsList) {
      await db?.narrationDao.insertNarration(narration);
    }
  }

  Future<void> deleteNarrationsList(List<Narration> narrationsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (Narration narration in narrationsList) {
      await db?.narrationDao.deleteNarration(narration);
    }
  }
}
