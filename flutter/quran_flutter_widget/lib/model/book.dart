import 'package:floor/floor.dart';

import 'base_model.dart';

/*
 foreignKeys: [
  ForeignKey(
      childColumns: ['narration'], parentColumns: ['id'], entity: Narration)
]
 */

@Entity(
  tableName: 'Book',
)
class Book extends BaseModel {
  @primaryKey
  int? id;
  String? name;
  @ColumnInfo(name: 'narration')
  int? narrationId;
  bool? downloaded;

  Book({
    this.id,
    this.name,
    this.narrationId,
    this.downloaded,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'narration': narrationId,
      'downloaded': downloaded,
    };
  }

  Book copyWith({
    int? id,
    String? name,
    int? narrationId,
    bool? downloaded,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      narrationId: narrationId ?? this.narrationId,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, name: $name, narrationId: $narrationId, downloaded: $downloaded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.name == name &&
        other.narrationId == narrationId &&
        other.downloaded == downloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        narrationId.hashCode ^
        downloaded.hashCode;
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map['id']?.toInt(),
      name: map['name'],
      narrationId: map['narration']?.toInt(),
      downloaded: map['downloaded'],
    );
  }
}
