import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';

@dao
abstract class TajweedDao {
  @Query('SELECT * FROM tajweed')
  Future<List<TajweedBook>> findAllTajweed();

  @Query(
      'SELECT * FROM tajweed WHERE narration = :narrationId and name like :qurey or author like :qurey')
  Future<List<TajweedBook>> findAllTajweedQurey(
    String qurey,
    int narrationId,
  );

  @Query('SELECT * FROM tajweed WHERE name like :qurey or author like :qurey')
  Future<List<TajweedBook>> searchInTajweeds(String qurey);

  @Query('SELECT * FROM tajweed WHERE narration = :narrationId')
  Future<List<TajweedBook>> findTajweedInNarrationId(int narrationId);

  @Query('SELECT * FROM tajweed WHERE id = :id')
  Stream<TajweedBook?> findTajweedById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTajweed(TajweedBook tajweedModel);

  @update
  Future<void> updateTajweed(TajweedBook tajweedModel);

  @delete
  Future<void> deleteTajweed(TajweedBook tajweedModel);
}
