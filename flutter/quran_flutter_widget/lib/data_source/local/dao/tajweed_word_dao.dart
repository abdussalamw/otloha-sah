import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';

@dao
abstract class TajweedWordDao {
  @Query('SELECT * FROM tajweed_charchter where book = :bookId')
  Future<List<TajweedCharacters>> findAllTajweedCharacters(int bookId);

  @Query('SELECT * FROM tajweed_charchter WHERE name like :qurey')
  Future<List<TajweedCharacters>> searchInTajweedCharacters(String qurey);

  @Query(
      'SELECT * FROM tajweed_charchter where book = :bookId and chapter = :chapter')
  Future<List<TajweedCharacters>> findAllTajweedChapter(
      int bookId, int chapter);

  @Query(
      'SELECT * FROM tajweed_charchter where book = :bookId and verse = :verse')
  Future<List<TajweedCharacters>> findAllTajweedVerse(int bookId, int verse);

  @Query(
      'SELECT * FROM tajweed_charchter where book = :bookId and verse_number = :verseNumber and chapter_number = :chapterNumber')
  Future<List<TajweedCharacters>> findAllTajweedVerseNumberAndChapter(int bookId, int verseNumber, int chapterNumber);

  @Query(
      'SELECT * FROM tajweed_charchter where book = :bookId and word = :word')
  Future<List<TajweedCharacters>> findAllTajweedWord(int bookId, int word);

  @Query(
      'SELECT * FROM tajweed_charchter WHERE where book = :bookId and narration = :narrationId')
  Future<List<TajweedCharacters>> findTajweedWordsInNarrationId(
      int bookId, int narrationId);

  @Query('SELECT * FROM tajweed_charchter WHERE id = :id')
  Stream<TajweedCharacters?> findTajweedWordById(int id);

  @Query(
      'SELECT * FROM tajweed_charchter WHERE book = :bookId GROUP BY chapter')
  Future<List<TajweedCharacters>> getSavedChaptersByBookId(int bookId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTajweedWord(TajweedCharacters tajweedWord);

  @update
  Future<void> updateTajweedWord(TajweedCharacters tajweedWord);

  @delete
  Future<void> deleteTajweedWord(TajweedCharacters tajweedWord);
}
