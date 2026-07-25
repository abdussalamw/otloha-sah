import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(tableName: 'Word')
class Word extends BaseModel {
  @primaryKey
  final int id;
  final String text;
  final int narration;
  @ColumnInfo(name: 'chapter_number')
  final int chapterNumber;
  @ColumnInfo(name: 'verse_number')
  final int verseNumber;
  final int number;
  final int verse;
  @ColumnInfo(name: 'position_in_line')
  final int? positionInLine;
  @ColumnInfo(name: 'line_number')
  final int? lineNumber;
  @ColumnInfo(name: 'font_size')
  double? fontSize;

  Word({
    required this.id,
    required this.text,
    required this.narration,
    required this.chapterNumber,
    required this.verseNumber,
    required this.number,
    required this.verse,
    this.positionInLine,
    this.lineNumber,
    this.fontSize,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      text: json['text'],
      narration: json['narration'],
      chapterNumber: json['chapter_number'],
      verseNumber: json['verse_number'],
      number: json['number'],
      verse: json['verse'],
      positionInLine: json['position_in_line'],
      lineNumber: json['line_number'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'narration': narration,
      'chapter_number': chapterNumber,
      'verse_number': verseNumber,
      'number': number,
      'verse': verse,
      'position_in_line': positionInLine,
      'line_number': lineNumber,
    };
  }
}
