import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/verse.dart';

@dao
abstract class VerseDao {
  @Query('SELECT * FROM Verse WHERE narration = :narration')
  Future<List<Verse>> findAllVerses(int narration);

  @Query('SELECT * FROM Verse WHERE page = :page')
  Future<List<Verse>> findAllVersesPage(int page);

  @Query('SELECT * FROM Verse WHERE narration = :narration and book = :book;')
  Future<List<Verse>> findAllVersesByBookAndNarration(int book, int narration);

  @Query(
      'SELECT * FROM Verse WHERE page = :page and narration = :narration and book = :book;')
  Future<List<Verse>> findAllVersesChapterPage(
      int page, int narration, int book);

  @Query('SELECT * FROM Verse WHERE id = :id')
  Stream<Verse?> findVerseById(int id);

  @Query('SELECT * FROM Verse WHERE id BETWEEN :first AND :last')
  Future<List<Verse>> findVersesBetween(int first, int last);

  @Query(
      'SELECT * FROM Verse WHERE page_number = :pageNumber AND narration = :narrationId')
  Future<List<Verse>> filterVersesByPageNumberAndNarrationId(
      int pageNumber, int narrationId);

  @Query(
      'SELECT * FROM Verse WHERE page_number BETWEEN :startPage AND :endPage AND narration = :narrationId')
  Future<List<Verse>> filterVersesByPageNumberAndNarrationIdBetweenPages(
      int narrationId, int startPage, int endPage);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVerse(Verse verse);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVersesList(List<Verse> verses);

  @update
  Future<void> updateVerse(Verse verse);

  @delete
  Future<void> deleteVerse(Verse verse);
}
