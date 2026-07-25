import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';

@dao
abstract class ExplanationVerseDao {
  @Query('SELECT * FROM explanation_verse where explanation = :explanation')
  Future<List<ExplanationVerse>> findAllExplanationVerse(int explanation);

  @Query('SELECT * FROM explanation_verse WHERE text like :qurey')
  Future<List<ExplanationVerse>> searchInExplanationVerse(String qurey);

  @Query('SELECT * FROM explanation_verse WHERE verse_number = :verse ')
  Future<List<ExplanationVerse>> findExplanationVersesFliterVerse(
    int verse,
  );

  @Query('SELECT * FROM explanation_verse WHERE chapter = :chapter ')
  Future<List<ExplanationVerse>> findExplanationVersesFliterChapter(
    int chapter,
  );

  @Query(
      'SELECT * FROM explanation_verse WHERE explanation = :bookId GROUP BY chapter')
  Future<List<ExplanationVerse>> getSavedChaptersByBookId(int bookId);

  @Query('SELECT * FROM explanation_verse WHERE page_number = :page ')
  Future<List<ExplanationVerse>> findExplanationVersesFliterPage(
    int page,
  );

  @Query('SELECT * FROM explanation_verse WHERE id = :id')
  Stream<ExplanationVerse?> findExplanationById(int id);

  @Query('SELECT * FROM explanation_verse WHERE verse = :verse')
  Future<ExplanationVerse?> findExplanationVersesByVerse(int verse);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertExplanationVerse(ExplanationVerse explanation);

  @update
  Future<void> updateExplanationVerse(ExplanationVerse explanation);

  @delete
  Future<void> deleteExplanationVerse(ExplanationVerse explanation);
}
