import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';

/*
foreignKeys: [
  ForeignKey(childColumns: ['chapter'], parentColumns: ['id'], entity: Chapter),
  ForeignKey(childColumns: ['page'], parentColumns: ['id'], entity: Page),
  ForeignKey(childColumns: ['verse'], parentColumns: ['id'], entity: Verse),
] */

@Entity(
  tableName: 'Glyph',
)
class Glyph extends BaseModel {
  @primaryKey
  int? id;
  @ColumnInfo(name: 'verse')
  int? verseId;
  @ColumnInfo(name: 'page')
  int? pageId;
  @ColumnInfo(name: 'chapter')
  int? chapterId;
  @ColumnInfo(name: 'line_number')
  int? lineNumber;
  int? position;
  int? minX;
  int? maxX;
  int? minY;
  int? maxY;

  Glyph(
    this.id,
    this.verseId,
    this.pageId,
    this.chapterId,
    this.lineNumber,
    this.position,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['verse'] = verseId;
    data['page'] = pageId;
    data['chapter'] = chapterId;
    data['line_number'] = lineNumber;
    data['position'] = position;
    data['min_x'] = minX;
    data['max_x'] = maxX;
    data['min_y'] = minY;
    data['max_y'] = maxY;
    return data;
  }

  Glyph copyWith({
    int? id,
    int? verseId,
    int? pageId,
    int? chapterId,
    int? lineNumber,
    int? position,
    int? minX,
    int? maxX,
    int? minY,
    int? maxY,
  }) {
    return Glyph(
      id ?? this.id,
      verseId ?? this.verseId,
      pageId ?? this.pageId,
      chapterId ?? this.chapterId,
      lineNumber ?? this.lineNumber,
      position ?? this.position,
      minX ?? this.minX,
      maxX ?? this.maxX,
      minY ?? this.minY,
      maxY ?? this.maxY,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verse': verseId,
      'page': pageId,
      'chapter': chapterId,
      'line_number': lineNumber,
      'position': position,
      'minX': minX,
      'maxX': maxX,
      'minY': minY,
      'maxY': maxY,
    };
  }

  factory Glyph.fromJson(Map<String, dynamic> map) {
    return Glyph(
      map['id']?.toInt(),
      map['verse']?.toInt(),
      map['page']?.toInt(),
      map['chapter']?.toInt(),
      map['line_number']?.toInt(),
      map['position']?.toInt(),
      map['minX']?.toInt(),
      map['maxX']?.toInt(),
      map['minY']?.toInt(),
      map['maxY']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'Glyph(id: $id, verseId: $verseId, pageId: $pageId, chapterId: $chapterId, lineNumber: $lineNumber, position: $position, minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Glyph &&
        other.id == id &&
        other.verseId == verseId &&
        other.pageId == pageId &&
        other.chapterId == chapterId &&
        other.lineNumber == lineNumber &&
        other.position == position &&
        other.minX == minX &&
        other.maxX == maxX &&
        other.minY == minY &&
        other.maxY == maxY;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        verseId.hashCode ^
        pageId.hashCode ^
        chapterId.hashCode ^
        lineNumber.hashCode ^
        position.hashCode ^
        minX.hashCode ^
        maxX.hashCode ^
        minY.hashCode ^
        maxY.hashCode;
  }
}
