part of '../database/database.dart';

@DriftAccessor(tables: [Recitations])
class RecitationsDao extends DatabaseAccessor<AppDatabase>
    with _$RecitationsDaoMixin {
  RecitationsDao(super.attachedDatabase);
  Future<int> insert(Recitation recitation) async {
    return into(recitations).insert(
      recitation,
      mode: InsertMode.insertOrReplace,
    );
  }
  //   recitation.id = await AppDatabase._db!.insert(
  //       RunQueries.downloadedRecitations, recitation.toDBJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   return recitation;
  // }

  Future<List<Recitation>> findAllUserRecitations(int userId) async {
    return (select(recitations)..where((tbl) => tbl.ownerId.equals(userId)))
        .get();
  }
  //   final dir = await getApplicationDocumentsDirectory(); tbl.owner.converter.fromSql(tbl.owner).id == userId
  //   List<Map<String, dynamic>> maps = await AppDatabase._db!.query(
  //       RunQueries.downloadedRecitations,
  //       where: 'user_id = ?',
  //       whereArgs: [UserDataServices.instance.getUserDataFast()?.id]);
  //   List<Recitation> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(Recitation.fromDBJson(item, dirPath: dir.path));
  //     }
  //     return items;
  //   }
  //   return null;
  // }
}
