import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';

/*
 * , foreignKeys: [
  ForeignKey(
      childColumns: ['recitation'], parentColumns: ['id'], entity: Recitation),
  ForeignKey(childColumns: ['chapter'], parentColumns: ['id'], entity: Chapter),
]
 */

@Entity(tableName: 'RecitationVerses')
class RecitationVerses extends BaseModel {
  @primaryKey
  int? id;
  @ColumnInfo(name: 'verse_number')
  int? verseNumber;
  @ColumnInfo(name: 'recitation')
  int? recitationId;
  @ColumnInfo(name: 'chapter')
  int? chapterId;
  String? record;
  String? recordLocal;

  RecitationVerses(
    this.id,
    this.chapterId,
    this.verseNumber,
    this.recitationId,
    this.record,
    this.recordLocal,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['cahpter'] = chapterId;
    data['verse_number'] = verseNumber;
    data['recitation'] = recitationId;
    data['record'] = record;
    return data;
  }

  RecitationVerses copyWith({
    int? id,
    int? chapterId,
    int? verseNumber,
    int? recitationId,
    String? record,
    String? recordLocal,
  }) {
    return RecitationVerses(
      id ?? this.id,
      chapterId ?? this.chapterId,
      verseNumber ?? this.verseNumber,
      recitationId ?? this.recitationId,
      record ?? this.record,
      recordLocal ?? this.recordLocal,
    );
  }

  factory RecitationVerses.fromJson(Map<String, dynamic> map) {
    return RecitationVerses(
      map['id']?.toInt(),
      map['chapter']?.toInt(),
      map['verse_number']?.toInt(),
      map['recitation']?.toInt(),
      map['record'],
      map['recordLocal'],
    );
  }

  @override
  String toString() {
    return 'RecitationVerses(id: $id, chapterId: $chapterId, verseNumber: $verseNumber, recitationId: $recitationId, record: $record, recordLocal: $recordLocal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecitationVerses &&
        other.id == id &&
        other.chapterId == chapterId &&
        other.verseNumber == verseNumber &&
        other.recitationId == recitationId &&
        other.record == record &&
        other.recordLocal == recordLocal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterId.hashCode ^
        verseNumber.hashCode ^
        recitationId.hashCode ^
        record.hashCode ^
        recordLocal.hashCode;
  }
}
