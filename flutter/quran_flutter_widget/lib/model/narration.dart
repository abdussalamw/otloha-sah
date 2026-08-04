import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(tableName: 'Narration')
class Narration extends BaseModel {
  @primaryKey
  final int id;
  final String name;
  final String description;

  factory Narration.fromJson(Map<String, dynamic> json) {
    return Narration.fromMap(json);
  }

  Narration({
    required this.id,
    required this.name,
    required this.description,
  });

  Narration.create(this.id, this.name, this.description);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  Narration copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Narration(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory Narration.fromMap(Map<String, dynamic> map) {
    String? nameStr = map['name'] is Map
        ? ((map['name'] as Map)['ar']?.toString() ?? (map['name'] as Map).values.first?.toString())
        : map['name']?.toString();

    String? descStr = map['description'] is Map
        ? ((map['description'] as Map)['ar']?.toString() ?? (map['description'] as Map).values.first?.toString())
        : map['description']?.toString();

    return Narration(
      id: map['id']?.toInt() ?? 1,
      name: nameStr ?? '',
      description: descStr ?? '',
    );
  }

  @override
  String toString() =>
      'Narration(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Narration &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
