import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/part.dart';

class PartLocalDataSource{

  Future<List<Part>?> fetchPartsList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.partDao.findAllParts();
  }

  Future<Part?> fetchPartById(int partId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.partDao.findPartById(partId).first;
  }

  Future<void> savePartsList(List<Part> partsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var part in partsList) {
      await db?.partDao.insertPart(part);
    }
  }

  Future<void> deletePartsList(List<Part> partsList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var part in partsList) {
      await db?.partDao.deletePart(part);
    }
  }
}