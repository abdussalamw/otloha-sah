import 'package:drift/drift.dart';

class VerseNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get idFromVerse => integer()();
  IntColumn get idToVerse => integer()();
  IntColumn get idPage => integer()();
  TextColumn get textFristVerse => text().withLength(min: 0, max: 255)();
  TextColumn get noteText => text().withLength(min: 0, max: 255)();
}
