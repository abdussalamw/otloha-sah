part of '../database/database.dart';

@DriftAccessor(tables: [FavoriteVerses])
class FavoriteVersesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoriteVersesDaoMixin {
  FavoriteVersesDao(super.attachedDatabase);
  Future<Future<List<FavoriteVerse>>> findAll(int userId) async {
    return (select(favoriteVerses)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<FavoriteVerse?> findById(int id, int userId) async {
    return (select(favoriteVerses)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insert(FavoriteVerse favoriteVerse) async {
    return into(favoriteVerses).insert(favoriteVerse);
  }

  Future<int> deleteVerse(int id) async {
    return (delete(favoriteVerses)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> updateVerse(FavoriteVerse favoriteVerse) async {
    return update(favoriteVerses).replace(favoriteVerse);
  }
}
