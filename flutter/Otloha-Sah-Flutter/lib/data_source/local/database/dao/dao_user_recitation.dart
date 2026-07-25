part of '../database/database.dart';

@DriftAccessor(tables: [LocalRecitations])
class LocalRecitationsDao extends DatabaseAccessor<AppDatabase>
    with _$LocalRecitationsDaoMixin {
  LocalRecitationsDao(super.attachedDatabase);

  Future<List<LocalRecitation>> findAllUserRecitations(int userId) async {
    return (select(localRecitations)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }
  //   List<Map<String, dynamic>> maps =
  //       await AppDatabase._db!.query(RunQueries.userRecitationName);
  //   List<UserRecitation> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(UserRecitation.fromMap(item));
  //     }

  //     return items;
  //   }
  //   return null;
  // }

  // Future<List<UserRecitation>> findUserRecitation(int userId) async {}
  //   List<Map<String, dynamic>> maps = await AppDatabase._db!.query(
  //       RunQueries.userRecitationName,
  //       where: 'user_id = ?',
  //       whereArgs: [userId]);

  //   List<UserRecitation> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(UserRecitation.fromMap(item));
  //     }
  //     return items;
  //   }
  //   return [];
  // }

  Future<LocalRecitation> insertRecitation(
      LocalRecitation localRecitation) async {
    int id = await into(localRecitations)
        .insert(localRecitation as Insertable<LocalRecitation>);
    return (select(localRecitations)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<int> deleteRecitation(int id) async {
    return (delete(localRecitations)..where((tbl) => tbl.id.equals(id))).go();
  }
  //   return await AppDatabase._db!.delete(
  //     RunQueries.userRecitationName,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future<bool> updateRecitaion(LocalRecitation localRecitation) async {
    return update(localRecitations)
        .replace(localRecitation as Insertable<LocalRecitation>);
  }
  //   return await AppDatabase._db!.update(
  //       RunQueries.userRecitationName, userRecitation.toMap(),
  //       where: 'uid = ?', whereArgs: [userRecitation.id]);
  // }
}
