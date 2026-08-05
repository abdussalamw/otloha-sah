import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import 'database/database.dart';

class DatabaseRepository {
  static final DatabaseRepository _ds = DatabaseRepository._internalInstance();

  DatabaseRepository._internalInstance();

  static DatabaseRepository get instance => _ds;

  factory DatabaseRepository() => instance;

  static final AppDatabase _database = AppDatabase();
  static FavoritePagesDao? favoritePagesDao;
  static VerseNotesDao? verseNoteDao;
  static FavoriteVersesDao? favoriteVersesDao;
  static UsersDao? usersDao;
  static LocalRecitationsDao? localRecitationsDao;
  static RecitationsDao? recitationsDao;

  Future<DatabaseRepository> get initDb async {
    favoritePagesDao = _database.favoritePagesDao;
    verseNoteDao = _database.verseNotesDao;
    usersDao = _database.usersDao;
    favoriteVersesDao = _database.favoriteVersesDao;
    localRecitationsDao = _database.localRecitationsDao;
    recitationsDao = _database.recitationsDao;

    return this;
  }

  // Verse Liked
  findAllVerseLikeds(int userId) async =>
      await favoriteVersesDao!.findAll(userId);

  findVerseLikedById(int id, int userId) async =>
      await favoriteVersesDao!.findById(id, userId);

  Future<FavoriteVerse> insertVerseLiked(FavoriteVerse verseLiked) async {
    int id = await favoriteVersesDao!.insert(verseLiked);
    return verseLiked.copyWith(id: id);
  }

  updateVerseLiked(verseLiked) async => favoriteVersesDao!.update(verseLiked);

  Future<int> deleteVerseLiked(int id) async =>
      await favoriteVersesDao!.deleteVerse(id);

  // Verse Note
  findAllVerseNotes(int userId) async => await verseNoteDao!.findAll(userId);

  findVerseNoteById(int id) async => await verseNoteDao!.findById(id);

  Future<int> insertVerseNote(VerseNote verseNote) async =>
      await verseNoteDao!.insertNote(verseNote);

  updateVerseNote(VerseNote verseNote) async =>
      verseNoteDao!.updateNote(verseNote);

  Future<int> deleteVerseNote(int id) async =>
      await verseNoteDao!.removeNote(id);

  // Page Marked
  findAllPageMarkeds(int userId) async =>
      await favoritePagesDao!.findAll(userId);

  // findPageMarkedById(int id, int userId) async =>
  //     await favoritePagesDao!.findById(id, userId);

  Future<FavoritePage> insertPageMarked(FavoritePage pageMarked) async {
    int id = await favoritePagesDao!.insert(pageMarked);
    return pageMarked.copyWith(id: id);
  }

  updatePageMarked(pageMarked) async => favoritePagesDao!.update(pageMarked);

  deletePageMarked(int id) async => favoritePagesDao!.deletePage(id);

  ///
  // User
  // findAllUsers(int userId) async => await usersDao!.();

  findUserById(int id) async => await usersDao!.findUser(id);

  insertUser(User user) async => await usersDao!.insertUser(user);

  updateUser(User user) async => await usersDao!.updateUser(user);

  // deleteUser(int id) async => await usersDao!.delete(id);

  Future<User?> getUser(int userId) async => await usersDao!.findUser(userId);
  Future<User?> getFavTeacher(int id) async => await usersDao!.findUser(id);

  // deleteUserAll() async => await usersDao!.deleteUserAll();

  /// user recitation
  insertUserRecitations(LocalRecitation recitation) async =>
      await localRecitationsDao!.insertRecitation(recitation);

  fetchUserRecitations(int userId) async =>
      await localRecitationsDao!.findAllUserRecitations(userId);

  deleteUserRecitation(int id) async =>
      await localRecitationsDao!.deleteRecitation(id);

  /// downloadedRecitation
  downloadRecitation(Recitation recitation) =>
      recitationsDao!.insert(recitation);

  Future<List<Recitation>?> fetchDownloadedRecitations(int userId) =>
      recitationsDao!.findAllUserRecitations(userId);
}
