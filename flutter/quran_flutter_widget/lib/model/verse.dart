import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';
import 'package:quran_widget_flutter/model/word.dart';

/*
 foreignKeys: [
  ForeignKey(
      childColumns: ['narration'], parentColumns: ['id'], entity: Narration),
  ForeignKey(childColumns: ['chapter'], parentColumns: ['id'], entity: Chapter),
  ForeignKey(childColumns: ['book'], parentColumns: ['id'], entity: Book),
  ForeignKey(childColumns: ['part'], parentColumns: ['id'], entity: Part),
  ForeignKey(childColumns: ['page'], parentColumns: ['id'], entity: Page),
]
 */

@Entity(
  tableName: 'Verse',
)

/* DatabaseException(FOREIGN KEY constraint failed (code 787 SQLITE_CONSTRAINT_FOREIGNKEY)) sql 
'INSERT OR ABORT INTO Verse 
(id, text, uthmanic_text, line_start, line_end, image, narration, chapter, book, part, page, verse_number) VALUES
 (?, ?, ?, ?, ?, NULL, ?, ?, ?, ?, ?, ?)' args [1, بسم الله الرحمن الرحيم, بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ ١, 2, 2, 1, 1, 1, 1, 1, 1]
*/

class Verse extends BaseModel {
  @primaryKey
  int? id;
  String? text;
  @ColumnInfo(name: 'uthmanic_text')
  String? uthmanicText;
  @ColumnInfo(name: 'line_start')
  int? lineStart;
  @ColumnInfo(name: 'line_end')
  int? lineEnd;
  String? image;
  @ColumnInfo(name: 'narration')
  int? narrationId;
  @ColumnInfo(name: 'chapter')
  int? chapterId;
  @ColumnInfo(name: 'book')
  int? bookId;
  @ColumnInfo(name: 'part')
  int? partId;
  @ColumnInfo(name: 'page')
  int? pageId;
  @ColumnInfo(name: 'page_number')
  int? pageNumber;
  @ColumnInfo(name: 'verse_number')
  int? verseNumber;
  @ColumnInfo(name: 'chapter_number')
  int? chapterNumber;
  @ignore
  List<Word>? words;
  Verse({
    this.id,
    this.text,
    this.uthmanicText,
    this.lineStart,
    this.lineEnd,
    this.image,
    this.narrationId,
    this.chapterId,
    this.bookId,
    this.partId,
    this.pageId,
    this.verseNumber,
    this.words,
    this.pageNumber,
    this.chapterNumber,
  });

  Verse copyWith({
    int? id,
    String? text,
    String? uthmanicText,
    int? lineStart,
    int? lineEnd,
    String? image,
    int? narrationId,
    int? chapterId,
    int? bookId,
    int? partId,
    int? pageId,
    int? verseNumber,
  }) {
    return Verse(
      id: id ?? this.id,
      text: text ?? this.text,
      uthmanicText: uthmanicText ?? this.uthmanicText,
      lineStart: lineStart ?? this.lineStart,
      lineEnd: lineEnd ?? this.lineEnd,
      image: image ?? this.image,
      narrationId: narrationId ?? this.narrationId,
      chapterId: chapterId ?? this.chapterId,
      bookId: bookId ?? this.bookId,
      partId: partId ?? this.partId,
      pageId: pageId ?? this.pageId,
      verseNumber: verseNumber ?? this.verseNumber,
      pageNumber: pageNumber,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'uthmanic_text': uthmanicText,
      'line_start': lineStart,
      'line_end': lineEnd,
      'image': image,
      'narration': narrationId,
      'chapter': chapterId,
      'book': bookId,
      'part': partId,
      'page': pageId,
      'verse_number': verseNumber,
    };
  }

/*
        "id": 12  73,
        "text": "\u0628\u0633\u0645 \u0627\u0644\u0644\u0647 \u0627\u0644\u0631\u062d\u0645\u0646 \u0627\u0644\u0631\u062d\u064a\u0645",
        "uthmanic_text": "\u0628\u0650\u0633\u06e1\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u06e1\u0645\u064e\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650\u00a0\u0661",
        "line_start": 2,
        "line_end": 2,
        "image": null,
        "book": 1,
        "part": 1,
        "page": 2,
        "narration": 1,
        "chapter": 1,
        "verse_number": 1 */

  factory Verse.fromJson(Map<String, dynamic> map) {
    List<Word> words = [];
    if (map.containsKey('words')) {
      for (var word in map['words']) {
        words.add(Word.fromJson(word));
      }
    }

    return Verse(
      id: map['id']?.toInt(),
      text: map['text'],
      uthmanicText: map['uthmanic_text'],
      lineStart: map['line_start']?.toInt(),
      lineEnd: map['line_end']?.toInt(),
      image: map['image'],
      narrationId: map['narration']?.toInt(),
      chapterId: map['chapter']?.toInt(),
      bookId: map['book']?.toInt(),
      partId: map['part']?.toInt(),
      pageId: map['page']?.toInt(),
      verseNumber: map['verse_number']?.toInt(),
      pageNumber: map['page_number']?.toInt(),
      words: words,
      chapterNumber: map['chapter_number'],
    );
  }

  @override
  String toString() {
    return 'Verse(id: $id, text: $text, words: $words, pageNumber: $pageNumber, uthmanicText: $uthmanicText, lineStart: $lineStart, lineEnd: $lineEnd, image: $image, narrationId: $narrationId, chapterId: $chapterId, bookId: $bookId, partId: $partId, pageId: $pageId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Verse &&
        other.id == id &&
        other.text == text &&
        other.uthmanicText == uthmanicText &&
        other.lineStart == lineStart &&
        other.lineEnd == lineEnd &&
        other.image == image &&
        other.narrationId == narrationId &&
        other.chapterId == chapterId &&
        other.bookId == bookId &&
        other.partId == partId &&
        other.pageId == pageId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        uthmanicText.hashCode ^
        lineStart.hashCode ^
        lineEnd.hashCode ^
        image.hashCode ^
        narrationId.hashCode ^
        chapterId.hashCode ^
        bookId.hashCode ^
        partId.hashCode ^
        pageId.hashCode ^
        verseNumber.hashCode;
  }
}
