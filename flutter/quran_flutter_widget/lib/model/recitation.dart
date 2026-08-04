import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';
import 'package:quran_widget_flutter/model/reciter.dart';

/*
foreignKeys: [
  ForeignKey(
      childColumns: ['narration'], parentColumns: ['id'], entity: Narration),
  ForeignKey(childColumns: ['reciter'], parentColumns: ['id'], entity: Reciter)
]
 */

@Entity(
  tableName: 'Recitation',
)
class Recitation extends BaseModel {
  @primaryKey
  int? id;
  @ColumnInfo(name: 'narration')
  int? narrationId;
  @ColumnInfo(name: 'reciter')
  int? reciterId;
  String? name;
  @ignore
  Reciter? reciter;

  Recitation(this.id, this.narrationId, this.reciterId, this.name,
      {this.reciter});

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['narration'] = narrationId;
    data['reciter'] = reciterId;
    data['name'] = name;
    return data;
  }

  Recitation copyWith({
    int? id,
    int? narrationId,
    int? reciterId,
    String? name,
  }) {
    return Recitation(
      id ?? this.id,
      narrationId ?? this.narrationId,
      reciterId ?? this.reciterId,
      name ?? this.name,
      reciter: reciter,
    );
  }

  @override
  String toString() {
    return 'Recitation(id: $id, narrationId: $narrationId, reciterId: $reciterId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recitation &&
        other.id == id &&
        other.narrationId == narrationId &&
        other.reciterId == reciterId &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        narrationId.hashCode ^
        reciterId.hashCode ^
        name.hashCode;
  }

  factory Recitation.fromJson(Map<String, dynamic> map) {
    String? nameStr;
    if (map['name'] is Map) {
      nameStr = (map['name'] as Map)['ar']?.toString() ?? (map['name'] as Map)['en']?.toString() ?? (map['name'] as Map).values.first?.toString();
    } else if (map['name'] is String) {
      nameStr = map['name'];
    }

    return Recitation(
      map['id']?.toInt(),
      map['narration']?.toInt(),
      map['reciter']?.toInt(),
      nameStr,
    );
  }
}
