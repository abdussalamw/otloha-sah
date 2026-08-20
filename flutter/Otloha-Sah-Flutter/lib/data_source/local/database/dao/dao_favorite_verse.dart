part of '../database/database.dart';

@DriftAccessor(tables: [FavoriteVerses])
class FavoriteVersesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoriteVersesDaoMixin {
  FavoriteVersesDao(super.attachedDatabase);
  Future<List<FavoriteVerse>> findAll(int userId) async {
    return (select(favoriteVerses)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<FavoriteVerse?> findById(int id, int userId) async {
    return (select(favoriteVerses)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// البحث برقم الصفحة الفعلي (1-604) وليس بـ id الداخلي
  Future<FavoriteVerse?> findByPageNumber(int pageNumber, int userId) async {
    return (select(favoriteVerses)
          ..where(
              (tbl) => tbl.pageNumber.equals(pageNumber) & tbl.userId.equals(userId)))
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
