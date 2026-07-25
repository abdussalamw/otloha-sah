import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/part.dart';

@dao
abstract class PartDao {
  @Query('SELECT * FROM Part')
  Future<List<Part>> findAllParts();

  @Query('SELECT * FROM Part WHERE name like :qurey or alias like :qurey ')
  Future<List<Part>> searchInPart(String qurey);

  @Query('SELECT * FROM Part WHERE id = :id')
  Stream<Part?> findPartById(int id);
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPart(Part part);

  @update
  Future<void> updatePart(Part part);

  @delete
  Future<void> deletePart(Part part);
}
