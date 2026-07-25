import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';

@UseRowClass(LocalRecitation)
class LocalRecitations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get narrationId => integer()();
  IntColumn get userId => integer()();
  IntColumn get chapterId => integer()();
  TextColumn get record => text()();
  TextColumn get versesList => text().map(ListConverter())();
  TextColumn get name => text()();
  BoolColumn get uploaded => boolean()();
}

class LocalRecitation implements Insertable<LocalRecitation> {
  int? id;
  int narrationId;
  int userId;
  int chapterId;
  String record;
  List<int> versesList;
  String name;
  bool uploaded;

  LocalRecitation({
    this.id,
    required this.narrationId,
    required this.record,
    required this.versesList,
    required this.name,
    this.uploaded = false,
    required this.chapterId,
    required this.userId,
  });

  LocalRecitation copyWith({
    required int chapterId,
    int? id,
    int? narrationId,
    String? record,
    List<int>? versesList,
    String? name,
    bool? uploaded,
  }) {
    return LocalRecitation(
      chapterId: chapterId,
      id: id ?? this.id,
      narrationId: narrationId ?? this.narrationId,
      record: record ?? this.record,
      versesList: versesList ?? this.versesList,
      name: name ?? this.name,
      uploaded: uploaded ?? this.uploaded,
      userId: userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'narration_id': narrationId,
      'user_id': UserDataServices.instance.getUserId(),
      'records': record,
      'verse_ids': jsonEncode(versesList),
      'name': name,
      'chapter_id': chapterId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocalRecitation &&
        other.id == id &&
        other.narrationId == narrationId &&
        other.record == record &&
        listEquals(other.versesList, versesList) &&
        other.name == name &&
        other.uploaded == uploaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        narrationId.hashCode ^
        record.hashCode ^
        versesList.hashCode ^
        name.hashCode ^
        uploaded.hashCode;
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    if (id != null) {
      return LocalRecitationsCompanion(
        id: Value(id!),
        narrationId: Value(narrationId),
        record: Value(record),
        versesList: Value(versesList),
        name: Value(name),
        uploaded: Value(uploaded),
        chapterId: Value(chapterId),
        userId: Value(userId),
      ).toColumns(nullToAbsent);
    }
    return LocalRecitationsCompanion(
      narrationId: Value(narrationId),
      record: Value(record),
      versesList: Value(versesList),
      name: Value(name),
      uploaded: Value(uploaded),
      chapterId: Value(chapterId),
      userId: Value(userId),
    ).toColumns(nullToAbsent);
  }
}

class ListConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> fromSql(String fromDb) {
    List<dynamic> decodedList = jsonDecode(fromDb);
    return decodedList.map((element) => element as int).toList();
  }

  @override
  String toSql(List<int> value) {
    return jsonEncode(value);
  }
}
