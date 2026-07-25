import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';

@dao
abstract class TranslationVerseDao {
  @Query('SELECT * FROM translation_verse where translation = :translation')
  Future<List<TranslationVerse>> findAllTranslationVerses(int translation);

  @Query('SELECT * FROM translation_verse WHERE id = :id')
  Stream<TranslationVerse?> findTranslationVerseById(int id);

  @Query('SELECT * FROM translation_verse WHERE chapter_number = :chapter ')
  Future<List<TranslationVerse>> findExplanationVersesFliterChapter(
    int chapter,
  );

  @Query(
      'SELECT * FROM translation_verse WHERE translation = :bookId GROUP BY chapter')
  Future<List<TranslationVerse>> getSavedChaptersByBookId(int bookId);

  @Query(
      'SELECT * FROM translation_verse WHERE translation = :translationId AND verse_number = :verseNumber AND chapter_number = :chapterNumber')
  Future<TranslationVerse?> findTranslationVerseByVerseId(
      int translationId, int verseNumber, int chapterNumber);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTranslationVerse(TranslationVerse translation);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTranslationVerseList(List<TranslationVerse> tranList);

  @update
  Future<void> updateTranslationVerse(TranslationVerse translation);

  @delete
  Future<void> deleteTranslationVerse(TranslationVerse translation);
}
