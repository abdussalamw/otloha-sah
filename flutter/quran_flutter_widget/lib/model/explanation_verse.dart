import 'package:floor/floor.dart';

import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'explanation_verse',
)
/*{
        "id": 2,
        "explanation": 1,
        "text": "[2] الثناء على الله بصفاته التي كلُّها أوصاف كمال، وبنعمه الظاهرة والباطنة، الدينية والدنيوية. وفي ضمنه أَمْرٌ لعباده أن يحمدوه، فهو المستحق له وحده، وهو سبحانه المنشئ للخلق، القائم بأمورهم، المربي لجميع خلقه بنعمه، ولأوليائه بالإيمان والعمل الصالح.",
        "verse_number": 2,
        "chapter_number": 1,
        "page_number": 1,
        "verse": null,
        "chapter": null
    } */
class ExplanationVerse extends BaseModel {
  @primaryKey
  int? id;
  int? explanation;
  String? text;
  @ColumnInfo(name: 'verse_number')
  int? verseNumber;
  @ColumnInfo(name: 'chapter_number')
  int? chapterNumber;
  @ColumnInfo(name: 'page_number')
  int? pageNumber;
  int? verse;
  int? chapter;

  ExplanationVerse({
    this.id,
    this.explanation,
    this.text,
    this.verseNumber,
    this.chapterNumber,
    this.pageNumber,
    this.chapter,
    this.verse,
  });

  factory ExplanationVerse.fromJson(Map<String, dynamic> json) {
    return ExplanationVerse(
      id: json['id'],
      explanation: json['explanation'],
      text: json['text'],
      verseNumber: json['verse_number'],
      chapterNumber: json['chapter_number'],
      pageNumber: json['page_number'],
      chapter: json['chapter'],
      verse: json['verse'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['explanation'] = explanation;
    data['text'] = text;
    data['verse_number'] = verseNumber;
    data['chapter_number'] = chapterNumber;
    data['page_number'] = pageNumber;
    data['verse'] = verse;
    data['chapter'] = chapter;
    return data;
  }
}
/*id
explanation
tafseer_text
verse_number
chapter_number
page_number */