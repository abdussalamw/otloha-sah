part of '../database/database.dart';

@DriftAccessor(tables: [FavoritePages])
class FavoritePagesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritePagesDaoMixin {
  FavoritePagesDao(super.attachedDatabase);
  Future<List<FavoritePage>> findAll(int userId) async {
    return (select(favoritePages)
          ..where((tbl) => tbl.userId.equals(userId) | tbl.userId.equals(0))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.pageNumber)]))
        .get();
  }

  Future<FavoritePage?> findById(int id, int userId) async {
    return (select(favoritePages)
          ..where((tbl) => tbl.idPage.equals(id) & (tbl.userId.equals(userId) | tbl.userId.equals(0))))
        .getSingleOrNull();
  }

  /// البحث برقم الصفحة الفعلي (1-604) وليس بـ idPage الداخلي
  Future<FavoritePage?> findByPageNumber(int pageNumber, int userId) async {
    return (select(favoritePages)
          ..where(
              (tbl) => tbl.pageNumber.equals(pageNumber) & (tbl.userId.equals(userId) | tbl.userId.equals(0))))
        .getSingleOrNull();
  }
  //   List<Map<String, dynamic>> maps = await AppDatabase._db!.query(
  //       RunQueries.pageMarkedName,
  //       where: userId == 0 ? 'idPage = ?' : 'idPage = ? and userId = ?',
  //       whereArgs: userId == 0 ? [id] : [id, userId]);
  //   List<PageMarked> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(PageMarked.fromMap(item));
  //     }
  //     return items.first;
  //   }
  //   return null;
  // }

  Future<int> insert(FavoritePage favoritePage) async {
    return into(favoritePages).insert(
      FavoritePagesCompanion.insert(
        id: favoritePage.id > 0 ? Value(favoritePage.id) : const Value.absent(),
        idPage: favoritePage.idPage,
        idBook: favoritePage.idBook,
        pageNumber: favoritePage.pageNumber,
        userId: favoritePage.userId,
        textVerse: favoritePage.textVerse,
      ),
    );
  }
  //   pageMarked.id = await AppDatabase._db!
  //       .insert(RunQueries.pageMarkedName, pageMarked.toMap());
  //   return pageMarked;
  // }

  Future<bool> updatePage(FavoritePage favoritePage) async {
    return update(favoritePages).replace(favoritePage);
  }

  Future<int> deletePage(int id) async {
    return (delete(favoritePages)..where((tbl) => tbl.id.equals(id))).go();
  }
  //   return await AppDatabase._db!
  //       .delete(RunQueries.pageMarkedName, where: 'id = ? ', whereArgs: [id]);
  // }

  // Future<int> update(PageMarked pageMarked) async {
  //   return await AppDatabase._db!.update(
  //       RunQueries.pageMarkedName, pageMarked.toMap(),
  //       where: 'uid = ?', whereArgs: [pageMarked.id]);
  // }
}
