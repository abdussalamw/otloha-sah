import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'tajweed_charchter',
)
class TajweedCharacters extends BaseModel {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'charchter_text')
  final String? chrachterText;
  @ColumnInfo(name: 'word_number')
  final int? wordNumber;
  @ColumnInfo(name: 'word_text')
  final String? wordText;
  final String? rule;
  @ColumnInfo(name: 'verse_number')
  final int? verseNumber;
  @ColumnInfo(name: 'character_text')
  final String? characterText;
  @ColumnInfo(name: 'charachter_number')
  final int? characterNumber;
  @ColumnInfo(name: 'rule_text')
  final String? ruleText;
  @ColumnInfo(name: 'chapter_number')
  final int? chapterNumber;
  final int? word;
  final int? chapter;
  final int? verse;
  final int? book;

  factory TajweedCharacters.fromJson(Map<String, dynamic> json) {
    return TajweedCharacters(
      id: json['id'],
      characterText: json['character_text'],
      ruleText: json['rule_text'],
      wordText: json['word_text'],
      characterNumber: json['character_number'],
      wordNumber: json['word_number'],
      verseNumber: json['verse_number'],
      chapterNumber: json['chapter_number'],
      word: json['word'],
      verse: json['verse'],
      chapter: json['chapter'],
      book: json['book'],
    );
  }

  TajweedCharacters({
    this.id,
    this.chrachterText,
    this.wordNumber,
    this.wordText,
    this.rule,
    this.verseNumber,
    this.characterText,
    this.characterNumber,
    this.ruleText,
    this.chapterNumber,
    this.word,
    this.chapter,
    this.verse,
    this.book,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['character_text'] = characterText;
    map['rule_text'] = ruleText;
    map['word_text'] = wordText;
    map['character_number'] = characterNumber;
    map['word_number'] = wordNumber;
    map['verse_number'] = verseNumber;
    map['chapter_number'] = chapterNumber;
    map['word'] = word;
    map['verse'] = verse;
    map['chapter'] = chapter;
    map['book'] = book;
    return map;
  }

  @override
  String toString() {
    print('$id $characterText, $ruleText $chapter');
    return super.toString();
  }
}
