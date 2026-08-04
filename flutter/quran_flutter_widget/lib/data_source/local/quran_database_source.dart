import 'package:quran_widget_flutter/data_source/local/quran_database.dart';

class QuranDatabaseSource {
  static final QuranDatabaseSource _db =
      QuranDatabaseSource._internalInstance();
  QuranDatabaseSource._internalInstance();
  static QuranDatabaseSource get instance => _db;
  static QuranDatabase? _database;

  Future<QuranDatabase?> get database async {
    _database ??= await $FloorQuranDatabase
        .databaseBuilder('quran_database_v2.db')
        .build();
    return _database;
  }
}
