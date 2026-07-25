import 'package:floor/floor.dart';

import 'base_model.dart';

@entity
class Part extends BaseModel {
  @primaryKey
  int? id;
  String? name;
  String? alias;
  @ColumnInfo(name: 'part_number')
  int? partNumber;

  Part(
    this.id,
    this.name,
    this.alias,
    this.partNumber,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['part_number'] = partNumber;
    return data;
  }

  Part copyWith({
    int? id,
    String? name,
    String? alias,
    int? partNumber,
  }) {
    return Part(
      id ?? this.id,
      name ?? this.name,
      alias ?? this.alias,
      partNumber ?? this.partNumber,
    );
  }

  factory Part.fromJson(Map<String, dynamic> map) {
    return Part(
      map['id']?.toInt(),
      map['name'],
      map['alias'],
      map['part_number']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'Part(id: $id, name: $name, alias: $alias, partNumber: $partNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Part &&
        other.id == id &&
        other.name == name &&
        other.alias == alias &&
        other.partNumber == partNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ alias.hashCode ^ partNumber.hashCode;
  }
}
