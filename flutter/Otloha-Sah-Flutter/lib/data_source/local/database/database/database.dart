import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/teacher_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as p;

import '../../../models/favorite_verses/favorite_verses.dart';
import '../../../models/notes/verse_note.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

import '../../../models/record/record.dart';

part '../dao/dao_user.dart';
part '../dao/dao_verse_note.dart';
part '../dao/dao_favorite_verse.dart';
part '../dao/dao_favorite_page.dart';
part '../dao/dao_user_recitation.dart';
part '../dao/dao_downloaded_recitations.dart';

part 'database.g.dart';

// class AppDatabase {
//   static Database? _db;
//   String? _path;

//   Future get database async {
//     if (_db == null) {
//       await open(await path);
//     }

//     return _db!;
//   }

//   /// Create tables
//   void _createTableCompanyV1(Database db) {
//     db.execute(
//       '''
//           CREATE TABLE IF NOT EXISTS "DownloadedUserRecitation" (
//               "id"	INTEGER NOT NULL,
//               "narration_id" INTEGER,
//               "verse_ids" TEXT,
//               "chapter_id" INTEGER,
//               "records" TEXT,
//               "owner" TEXT,
//               "teacher" TEXT,
//               "gender" TEXT,
//               "is_child" INTEGER,
//               "is_teacher_recitation" INTEGER,
//               "updated_at" TEXT,
//               "created_at" TEXT,
//               "teacher_rate" TEXT,
//               "owner_rate" TEXT,
//               "result" TEXT,
//               "is_remarkable" INTERGER,
//               "conversation_started" INTEGER,
//               "being_evaluated" INTEGER,
//               "evaluated_at" TEXT,
//               "is_closed" INTEGER,
//               "closed_at" TEXT,
//               "show_in_general" INTEGER,
//               "show_in_remarkable" INTEGER,
//               "user_id" INTEGER,
//               "local_record" TEXT,
//               "rate" Text
//           );''',
//     );
//   }

//   Future<String> get path async {
//     var databasesPath = await getDatabasesPath();
//     _path = join(databasesPath, 'quran.db');
//     return _path ?? '';
//   }

//   Future<Database> open(String path) async {
//     _db = await openDatabase(path, version: 4,
//         onCreate: (Database db, int version) async {
//       /// run create tables
//       RunQueries().runQueries(db);
//     }, onUpgrade: (db, prev, neww) {
//       if (neww == 3) _createTableCompanyV1(db);
//       if (neww == 4) {
//         db.execute(
//             'ALTER TABLE ${RunQueries.userName} ADD COLUMN "is_blocked" INTEGER DEFAULT 0');
//       }
//     }, onOpen: (db) async {
//       _createTableCompanyV1(db);
//     });

//     return _db!;
//   }

//   Future close() async => _db!.close();

//   VerseNoteDao get verseNoteDao => VerseNoteDao();
//   VerseLikedDao get verseLikedDao => VerseLikedDao();
//   PageMarkedDao get pageMarkedDao => PageMarkedDao();
//   UserRecitationDao get userRecitationDao => UserRecitationDao();
//   UserDao get userDao => UserDao();
//   DownloadedRecitationsDao get downloadedRecitationsDao =>
//       DownloadedRecitationsDao();

//   String join(String databasesPath, String databasesName) {
//     return '$databasesPath/$databasesName';
//   }
// }

@DriftDatabase(
  tables: [
    Users,
    Recitations,
    FavoriteVerses,
    FavoritePages,
    LocalRecitations,
    VerseNotes,
  ],
  daos: [
    VerseNotesDao,
    FavoriteVersesDao,
    UsersDao,
    FavoritePagesDao,
    LocalRecitationsDao,
    RecitationsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    // if (Platform.isAndroid) {
    //   await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    // }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
