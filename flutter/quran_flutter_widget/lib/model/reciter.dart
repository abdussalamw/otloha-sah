import 'package:floor/floor.dart';

import 'base_model.dart';

@entity
class Reciter extends BaseModel {
  @primaryKey
  int? id;
  String? name;

  Reciter(
    this.id,
    this.name,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  Reciter copyWith({
    int? id,
    String? name,
  }) {
    return Reciter(
      id ?? this.id,
      name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Reciter.fromJson(Map<String, dynamic> map) {
    return Reciter(
      map['id']?.toInt(),
      map['name'],
    );
  }

  @override
  String toString() => 'Reciter(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reciter && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
