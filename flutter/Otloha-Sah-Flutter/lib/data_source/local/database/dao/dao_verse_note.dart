part of '../database/database.dart';

@DriftAccessor(tables: [VerseNotes])
class VerseNotesDao extends DatabaseAccessor<AppDatabase>
    with _$VerseNotesDaoMixin {
  VerseNotesDao(super.attachedDatabase);

  Future<List<VerseNote>?> findAll(int userId) async {
    return (select(verseNotes)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<VerseNote?> findById(int id) async {
    return (select(verseNotes)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertNote(VerseNote verseNote) async {
    return into(verseNotes).insert(verseNote);
  }

  Future<int> removeNote(int id) async {
    return (delete(verseNotes)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> updateNote(VerseNote verseNote) async {
    return update(verseNotes).replace(verseNote);
  }
}
