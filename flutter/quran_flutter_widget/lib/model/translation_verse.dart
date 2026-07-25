import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'translation_verse',
  primaryKeys: ['verse_number', 'translation', 'chapter_number'],
)
class TranslationVerse extends BaseModel {
  String? text;
  int? chapter;
  @ColumnInfo(name: 'chapter_number')
  int? chapterNumber;
  @ColumnInfo(name: 'verse_number')
  @primaryKey
  int? verseNumber;
  @primaryKey
  int? translation;

  TranslationVerse({
    this.text,
    this.chapter,
    this.chapterNumber,
    this.verseNumber,
    this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'chapter': chapter,
      'chapterNumber': chapterNumber,
      'verseNumber': verseNumber,
      'translation': translation,
    };
  }

  factory TranslationVerse.fromJson(Map<String, dynamic> map) {
    return TranslationVerse(
      text: map['text'],
      chapter: map['chapter']?.toInt(),
      chapterNumber: map['chapter_number']?.toInt(),
      verseNumber: map['verse_number']?.toInt(),
      translation: map['translation']?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() => toMap();

  TranslationVerse copyWith({
    int? id,
    String? text,
    int? chapter,
    int? chapterNumber,
    int? verseNumber,
    int? translation,
  }) {
    return TranslationVerse(
      text: text ?? this.text,
      chapter: chapter ?? this.chapter,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      translation: translation ?? this.translation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TranslationVerse &&
        other.text == text &&
        other.chapter == chapter &&
        other.chapterNumber == chapterNumber &&
        other.verseNumber == verseNumber &&
        other.translation == translation;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        chapter.hashCode ^
        chapterNumber.hashCode ^
        verseNumber.hashCode ^
        translation.hashCode;
  }
}
