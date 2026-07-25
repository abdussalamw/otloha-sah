import 'package:quran_widget_flutter/data_source/local/quran_database_source.dart';
import 'package:quran_widget_flutter/model/book.dart';

class BookLocalDataSource {
  Future<List<Book>?> fetchBooksList() async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.bookDao.findAllBooks();
  }

  Future<List<Book>?> searchInBooks(String qurey) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.bookDao.searchInBooks('%$qurey%');
  }

  Future<List<Book>?> findBooksInNarrationId(int narrationId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.bookDao.findBooksInNarrationId(narrationId);
  }

  Future<Book?> fetchBookById(int bookId) async {
    final db = await QuranDatabaseSource.instance.database;
    return db?.bookDao.findBookById(bookId).first;
  }

  Future<void> saveBooksList(List<Book> booksList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var book in booksList) {
      await db?.bookDao.insertBook(book);
    }
  }

  Future<void> saveBook(Book book) async {
    final db = await QuranDatabaseSource.instance.database;
    await db?.bookDao.updateBook(book);
  }

  Future<void> deleteBooksList(List<Book> booksList) async {
    final db = await QuranDatabaseSource.instance.database;
    for (var book in booksList) {
      await db?.bookDao.deleteBook(book);
    }
  }
}
