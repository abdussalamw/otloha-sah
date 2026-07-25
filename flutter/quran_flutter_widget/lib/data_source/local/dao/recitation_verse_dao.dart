import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/recitation_verses.dart';

@dao
abstract class RecitationVersesDao {
  @Query('SELECT * FROM RecitationVerses')
  Future<List<RecitationVerses>> findAllRecitationsVerses();

  @Query('SELECT * FROM RecitationVerses WHERE id = :id')
  Stream<RecitationVerses?> findRecitationVersesById(int id);

  @Query(
      'SELECT * FROM RecitationVerses WHERE recitation = :recitationId AND chapter = :chapterId')
  Future<List<RecitationVerses>> findRecitationVersesChapterList(
      int chapterId, int recitationId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecitationVerses(RecitationVerses recitationVerses);

  @update
  Future<void> updateRecitationVerses(RecitationVerses recitationVerses);

  @delete
  Future<void> deleteRecitationVerses(RecitationVerses recitationVerses);
}
