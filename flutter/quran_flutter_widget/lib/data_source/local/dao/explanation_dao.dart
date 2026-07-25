import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/explanation.dart';

@dao
abstract class ExplanationDao {
  @Query('SELECT * FROM explanation ')
  Future<List<Explanation>> findAllExplanation();

  @Query('SELECT * FROM explanation WHERE name like :qurey')
  Future<List<Explanation>> searchInExplanation(String qurey);

  @Query('SELECT * FROM explanation WHERE narration = :narrationId')
  Future<List<Explanation>> findExplanationsByNarrationId(int narrationId);

  @Query('SELECT * FROM explanation WHERE id = :id')
  Stream<Explanation?> findExplanationById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertExplanation(Explanation explanation);

  @update
  Future<void> updateExplanation(Explanation explanation);

  @delete
  Future<void> deleteExplanation(Explanation explanation);
}
