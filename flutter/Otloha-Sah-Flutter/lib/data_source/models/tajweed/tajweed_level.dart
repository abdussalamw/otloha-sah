import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';

class TajweedLevel {
  final int id;
  final Translations name;
  final int completed;
  TajweedLevel({
    required this.id,
    required this.name,
    required this.completed,
  });

  TajweedLevel copyWith({
    int? id,
    Translations? name,
    int? compeleted,
  }) {
    return TajweedLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory TajweedLevel.fromMap(Map<String, dynamic> map) {
    return TajweedLevel(
      id: map['id'] as int,
      name: Translations.fromJson(map['name']),
      completed: map['completed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TajweedLevel.fromJson(String source) =>
      TajweedLevel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TajweedLevel(id: $id, name: $name)';

  @override
  bool operator ==(covariant TajweedLevel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
