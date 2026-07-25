import 'package:drift/drift.dart';

class FavoriteVerses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idFromVerse => integer()();
  IntColumn get idToVerse => integer()();
  IntColumn get idPage => integer()();
  IntColumn get userId => integer()();
  IntColumn get pageNumber => integer()();
  TextColumn get textFristVerse => text().withLength(min: 0, max: 255)();
}
