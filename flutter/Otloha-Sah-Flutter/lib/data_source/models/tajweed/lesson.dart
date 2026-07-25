// ignore_for_file: public_member_api_docs, sort_constructors_first
// lesson.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';

class Lesson {
  final int id;
  final Translations title;
  final int lessonLevel;
  final Translations content;
  final int numberOfChildren;
  final int completedLessons;
  final List<Map<String, String>> videoUrls;
  final List<LessonExample> lessonExamples;

  Lesson({
    required this.id,
    required this.title,
    required this.lessonLevel,
    required this.content,
    required this.numberOfChildren,
    required this.completedLessons,
    required this.videoUrls,
    required this.lessonExamples,
  });

  factory Lesson.fromMap(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: Translations.fromJson(Map<String, dynamic>.from(json['title'])),
      lessonLevel: json['lesson_level'],
      content:
          Translations.fromJson(Map<String, dynamic>.from(json['content'])),
      numberOfChildren: json['number_of_children'],
      completedLessons: json['completed_lessons'],
      videoUrls: (json['video_urls'] as List)
          .map((e) => Map<String, String>.from(e))
          .toList(),
      lessonExamples: (json['lesson_examples'] as List)
          .map((e) => LessonExample.fromJson(e))
          .toList(),
    );
  }

  Lesson copyWith({
    int? id,
    Translations? title,
    int? lessonLevel,
    Translations? content,
    int? numberOfChildren,
    int? completedLessons,
    List<Map<String, String>>? videoUrls,
    List<LessonExample>? lessonExamples,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonLevel: lessonLevel ?? this.lessonLevel,
      content: content ?? this.content,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      completedLessons: completedLessons ?? this.completedLessons,
      videoUrls: videoUrls ?? this.videoUrls,
      lessonExamples: lessonExamples ?? this.lessonExamples,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title.toJson(),
      'lessonLevel': lessonLevel,
      'content': content,
      'numberOfChildren': numberOfChildren,
      'completedLessons': completedLessons,
      'videoUrls': videoUrls,
    };
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(String source) =>
      Lesson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, lessonLevel: $lessonLevel, content: $content, numberOfChildren: $numberOfChildren, completedLessons: $completedLessons, videoUrls: $videoUrls, lessonExamples: $lessonExamples)';
  }

  @override
  bool operator ==(covariant Lesson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.lessonLevel == lessonLevel &&
        other.content == content &&
        other.numberOfChildren == numberOfChildren &&
        other.completedLessons == completedLessons &&
        listEquals(other.videoUrls, videoUrls) &&
        listEquals(other.lessonExamples, lessonExamples);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        lessonLevel.hashCode ^
        content.hashCode ^
        numberOfChildren.hashCode ^
        completedLessons.hashCode ^
        videoUrls.hashCode ^
        lessonExamples.hashCode;
  }
}

class LessonExample {
  final Translations title;
  final String record;
  final int verseNumber;
  final String verseText;
  final int chapter;

  LessonExample({
    required this.title,
    required this.record,
    required this.verseNumber,
    required this.verseText,
    required this.chapter,
  });

  factory LessonExample.fromJson(Map<String, dynamic> json) {
    return LessonExample(
      title: Translations.fromJson(Map<String, dynamic>.from(json['title'])),
      record: json['record'],
      verseNumber: json['verse_number'],
      verseText: json['verse_text'],
      chapter: json['chapter'],
    );
  }
}
