import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/word.dart';

class WordLocalDataSource {
  Future<List<Word>> findAllWords() async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.wordDao.findAllWords();
  }

  Future<List<Word>> findWordsByPageNumber() async {
    final db = await QuranDatabaseSource.instance.database;
    return db!.wordDao.findAllWords();
  }

  Future<void> insertWord(Word word) async {
    final db = await QuranDatabaseSource.instance.database;
    await db!.wordDao.insertWord(word);
  }

  Future<void> insertWordsList(List<Word> words) async {
    final db = await QuranDatabaseSource.instance.database;
    await db!.wordDao.insertWordsList(words);
  }

  Future<void> updatetWord(Word word) async {
    final db = await QuranDatabaseSource.instance.database;
    await db!.wordDao.updateWord(word);
  }

  Future<void> updatetWords(List<Word> words) async {
    final db = await QuranDatabaseSource.instance.database;
    await db!.wordDao.updateWords(words);
  }

  Future<void> deleteWord(Word word) async {
    final db = await QuranDatabaseSource.instance.database;
    await db!.wordDao.deleteWord(word);
  }
}
