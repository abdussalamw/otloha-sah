// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';

class TajweedLesson {
  final int id;
  final Translations title;
  final int level;
  final int numberOfChildren;
  final int completedLessons;
  TajweedLesson({
    required this.id,
    required this.title,
    required this.level,
    required this.numberOfChildren,
    required this.completedLessons,
  });

  TajweedLesson copyWith({
    int? id,
    Translations? title,
    int? level,
    int? numberOfChildren,
    int? completedLessons,
  }) {
    return TajweedLesson(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title.toJson(),
      'lesson_level': level,
      'number_of_children': numberOfChildren,
      'completed_lessons': completedLessons,
    };
  }

  factory TajweedLesson.fromMap(Map<String, dynamic> map) {
    return TajweedLesson(
      id: map['id'] as int,
      title: Translations.fromJson(map['title'] as Map<String, dynamic>),
      level: map['lesson_level'] as int,
      numberOfChildren: map['number_of_children'] as int,
      completedLessons: map['completed_lessons'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TajweedLesson.fromJson(String source) =>
      TajweedLesson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TajweedLesson(id: $id, title: $title, level: $level, numberOfChildren: $numberOfChildren, completedLessons: $completedLessons)';
  }

  @override
  bool operator ==(covariant TajweedLesson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.level == level &&
        other.numberOfChildren == numberOfChildren &&
        other.completedLessons == completedLessons;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        level.hashCode ^
        numberOfChildren.hashCode ^
        completedLessons.hashCode;
  }
}
