import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/word.dart';

@dao
abstract class WordDao {
  @Query('SELECT * FROM Word')
  Future<List<Word>> findAllWords();

  @Query(
      'SELECT * FROM Word WHERE verse BETWEEN :firstVerse AND :lastVerse ORDER BY number')
  Future<List<Word>> findWordsBetweenVerses(int firstVerse, int lastVerse);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWord(Word word);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWordsList(List<Word> word);

  @update
  Future<void> updateWord(Word word);

  @update
  Future<void> updateWords(List<Word> word);

  @delete
  Future<void> deleteWord(Word word);
}
