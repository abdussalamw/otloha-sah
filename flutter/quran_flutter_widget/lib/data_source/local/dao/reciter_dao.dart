import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/reciter.dart';

@dao
abstract class ReciterDao {
  @Query('SELECT * FROM Reciter')
  Future<List<Reciter>> findAllReciters();

  @Query('SELECT * FROM Reciter WHERE name like :qurey')
  Future<List<Reciter>> searchInReciter(String qurey);

  @Query('SELECT * FROM Reciter WHERE id = :id')
  Stream<Reciter?> findReciterById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertReciter(Reciter reciter);

  @update
  Future<void> updateReciter(Reciter reciter);

  @delete
  Future<void> deleteReciter(Reciter reciter);
}
