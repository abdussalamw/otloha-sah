import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/reciter.dart';

class ReciterLocalDataSource{

  Future<List<Reciter>?> fetchRecitersList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.reciterDao.findAllReciters();
  }
  Future<List<Reciter>?> searchRecitersList(String qurey) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.reciterDao.searchInReciter('%$qurey%');
  }

  Future<Reciter?> fetchReciterById(int reciterId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.reciterDao.findReciterById(reciterId).first;
  }

  Future<void> saveRecitersList(List<Reciter> recitersList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var reciter in recitersList) {
      await db?.reciterDao.insertReciter(reciter);
    }
  }

  Future<void> deleteRecitersList(List<Reciter> recitersList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var reciter in recitersList) {
      await db?.reciterDao.deleteReciter(reciter);
    }
  }
}