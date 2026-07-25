// part of 'database.dart';

// class RunQueries {
//   static const verseNoteName = 'VerseNote';
//   static const verseLikedName = 'VerseLiked';
//   static const pageName = 'Page';
//   static const pageMarkedName = 'PageMarked';
//   static const userName = 'user';
//   static const userRecitationName = 'UserRecitation';
//   static const downloadedRecitations = 'DownloadedUserRecitation';

//   runQueries(Database db) async {
//     var list = queries.split(';');

//     await db.transaction(
//       (txn) async {
//         for (var item in list) {
//           txn.execute(item);
//         }
//       },
//     );
//   }

//   final queries = '''
// CREATE TABLE IF NOT EXISTS "UserRecitation" (
// 	"id"	INTEGER NOT NULL,
// 	"narration_id"	INTEGER,
// 	"user_id"	INTEGER,
// 	"chapter_id"	INTEGER,
// 	"records"	TEXT,
// 	"verse_ids"	TEXT,
// 	"wavePath"	TEXT,
// 	"name"	TEXT,
// 	"uploaded"	INTEGER DEFAULT 0,
// 	"is_accepted"	INTEGER,
// 	"is_teacher_recitation"	INTEGER,
// 	"show_in_general"	INTEGER,
// 	"finished_at"	INTEGER,
// 	"archived_at"	INTEGER,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );

// CREATE TABLE IF NOT EXISTS "VerseNote" (
// 	"id"	INTEGER NOT NULL,
// 	"userId"	INTEGER NOT NULL,
// 	"idFromVerse"	INTEGER,
// 	"idToVerse"	INTEGER,
// 	"idPage"	INTEGER,
// 	"pageNumber"	INTEGER,
// 	"textFristVerse"	TEXT,
// 	"noteText"	TEXT,
// 	"text"	TEXT,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// CREATE TABLE IF NOT EXISTS "VerseLiked" (
// 	"id"	INTEGER NOT NULL,
// 	"userId"	INTEGER NOT NULL,
// 	"idFromVerse"	INTEGER NOT NULL,
// 	"idToVerse"	INTEGER,
// 	"idPage"	INTEGER,
// 	"pageNumber"	INTEGER,
// 	"textFristVerse"	TEXT,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// CREATE TABLE IF NOT EXISTS "PageMarked" (
// 	"id"	INTEGER NOT NULL,
// 	"userId"	INTEGER NOT NULL,
// 	"idPage"	INTEGER NOT NULL,
// 	"idBook"	INTEGER,
// 	"pageNumber"	INTEGER,
// 	"textVerse"	TEXT,
// 	PRIMARY KEY("id")
// );
// CREATE TABLE IF NOT EXISTS "user" (
// 	"id"	INTEGER NOT NULL,
// 	"phone"	TEXT,
// 	"email"	TEXT,
// 	"accessToken"	TEXT,
// 	"refreshToken"	TEXT, 
// 	"username"	TEXT,
// 	"first_name"	TEXT,
// 	"last_name"	TEXT,
// 	"bio"	TEXT,
// 	"level"	TEXT,
// 	"is_a_teacher"	INTEGER,
// 	"narrationId"	INTEGER,
// 	"image"	TEXT,
// 	"gender"	TEXT,
// 	"isFavorite"	INTEGER,
// 	"teacherType"	TEXT,
// 	"isCertified"	INTEGER,
// 	"favoriteTeacher"	INTEGER,
// 	"canReplyOnEveryVerseInRecitation"	INTEGER,
// 	"rate"	NUMERIC,
//   "birthdate"	TEXT,
//   "is_blocked" INTEGER, 
// 	PRIMARY KEY("id")
// );
// CREATE TABLE IF NOT EXISTS "DownloadedUserRecitation" (
//       "id"	INTEGER NOT NULL UNIQUE,
//       "narration_id" INTEGER,
//       "name" TEXT,
//       "verse_ids" TEXT,
//       "chapter_id" INTEGER,
//       "records" TEXT,
//       "owner" TEXT,
//       "teacher" TEXT,
//       "gender" TEXT,
//       "is_child" INTEGER,
//       "is_teacher_recitation" INTEGER,
//       "updated_at" TEXT,
//       "created_at" TEXT,
//       "teacher_rate" TEXT,
//       "owner_rate" TEXT,
//       "result" TEXT,
//       "is_remarkable" INTERGER,
//       "conversation_started" INTEGER,
//       "being_evaluated" INTEGER,
//       "evaluated_at" TEXT,
//       "is_closed" INTEGER,
//       "closed_at" TEXT,
//       "show_in_general" INTEGER,
//       "show_in_remarkable" INTEGER,
//       "user_id" INTEGER,
//       "local_record" TEXT,
//       "rate" Text 
//   );
// ''';
// }
