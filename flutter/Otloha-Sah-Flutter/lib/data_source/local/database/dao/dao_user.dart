part of '../database/database.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.attachedDatabase);
  // Future<List<UserModelDB>?> findAllUsers() async {
  //   List<Map<String, dynamic>> maps =
  //       await AppDatabase._db!.query(RunQueries.userName);
  //   List<UserModelDB> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(UserModelDB.fromMap(item));
  //     }

  //     return items;
  //   }
  //   return null;
  // }

  Future<User?> findUser(int id) async {
    print(await (select(users)..where((tbl) => tbl.id.equals(id))).get());
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
  //   List<Map<String, dynamic>> maps = await AppDatabase._db!
  //       .query(RunQueries.userName, where: 'id = ?', whereArgs: [id]);
  //   List<UserModelDB> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(UserModelDB.fromMap(item));
  //     }
  //     return items.first;
  //   }
  //   return null;
  // }

  Future<int> insertUser(User user) async {
    return into(users)
        .insert(user as Insertable<User>, mode: InsertMode.insertOrReplace);
  }
  //   final existingUser = await findUser(user.id);

  //   if (existingUser == null) {
  //     user.id = await AppDatabase._db!.insert(
  //       RunQueries.userName,
  //       user.toMap(),
  //       conflictAlgorithm:
  //           ConflictAlgorithm.ignore, // Ignore if the user already exists
  //     );
  //   } else {
  //     await AppDatabase._db!.update(
  //       RunQueries.userName,
  //       user.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [user.id],
  //     );
  //   }

  //   return user;
  // }

  // Future<int> delete(int id) async {
  //   return await AppDatabase._db!
  //       .delete(RunQueries.userName, where: 'id = ?', whereArgs: [id]);
  // }

  Future<bool> updateUser(User user) async {
    return update(users).replace(user as Insertable<User>);
  }
  //   return await AppDatabase._db!.update(RunQueries.userName, user.toMap(),
  //       where: 'id = ?', whereArgs: [user.id]);
  // }

  // Future<UserModelDB?> getUser(int? userId) async {
  //   List<Map<String, dynamic>> maps = await AppDatabase._db!
  //       .query(RunQueries.userName, where: 'id = ?', whereArgs: [userId]);
  //   List<UserModelDB> items = [];
  //   if (maps.isNotEmpty) {
  //     for (var item in maps) {
  //       items.add(UserModelDB.fromMap(item));
  //     }
  //     return items.first;
  //   }
  //   return null;
  // }

  Future<void> blockUser(int userId) async {
    (update(users)..where((tbl) => tbl.id.equals(userId)))
        .write(const UsersCompanion(isBlocked: Value(true)));
  }
  //   await AppDatabase._db!.update(
  //     'user',
  //     {'is_blocked': 1},
  //     where: 'id = ?',
  //     whereArgs: [userId],
  //   );
  // }

  Future<void> unblockUser(int userId) async {
    (update(users)..where((tbl) => tbl.id.equals(userId)))
        .write(const UsersCompanion(isBlocked: Value(false)));
  }
  //   await AppDatabase._db!.update(
  //     'user',
  //     {'is_blocked': 0},
  //     where: 'id = ?',
  //     whereArgs: [userId],
  //   );
  // }

  // deleteUserAll() async {
  //   return await AppDatabase._db!.delete(RunQueries.userName);
  // }
}
