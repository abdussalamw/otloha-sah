import 'package:quran_widget_flutter/model/base_model.dart';

enum SearchType {
  chapter,
  verse,
}

class Search extends BaseModel {
  final SearchType type;
  final dynamic result;

  Search({
    required this.type,
    required this.result,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = type.toString();
    if (type == SearchType.chapter) {
      data.addAll((result as ChapterSearchResult).toJson());
    } else if (type == SearchType.verse) {
      data.addAll((result as VerseSearchResult).toJson());
    }
    return data;
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      type: json['result_type'] == 'chapter'
          ? SearchType.chapter
          : json['result_type'] == 'verse'
              ? SearchType.verse
              : SearchType.verse,
      result: json['result_type'] == 'chapter'
          ? ChapterSearchResult.fromJson(json)
          : json['result_type'] == 'verse'
              ? VerseSearchResult.fromJson(json)
              : VerseSearchResult.fromJson(json),
    );
  }
}

class ChapterMetaData {
  int numberOfVerses;
  int fromPage;
  int toPage;
  ChapterMetaData({
    required this.numberOfVerses,
    required this.fromPage,
    required this.toPage,
  });

  factory ChapterMetaData.fromJson(Map<String, dynamic> json) {
    return ChapterMetaData(
      numberOfVerses: json['number_of_verses'],
      fromPage: json['from_page'],
      toPage: json['to_page'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number_of_verses'] = numberOfVerses;
    data['from_page'] = fromPage;
    data['to_page'] = toPage;
    return data;
  }
}

class ChapterSearchResult extends BaseModel {
  final int id;
  final String name;
  final int chapterNumber;
  final String origin;
  final String result;
  final Map<String, ChapterMetaData> chapterMetaData;

  ChapterSearchResult({
    required this.id,
    required this.name,
    required this.chapterNumber,
    required this.origin,
    required this.result,
    required this.chapterMetaData,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['chapter_number'] = chapterNumber;
    data['origin'] = origin;
    data['result'] = result;
    return data;
  }

  factory ChapterSearchResult.fromJson(Map<String, dynamic> json) {
    return ChapterSearchResult(
      id: json['id'],
      name: json['name'],
      chapterNumber: json['chapter_number'],
      origin: json['origin'],
      result: json['result_type'],
      chapterMetaData: json['chapter_metadata'] != null
          ? (json['chapter_metadata'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                ChapterMetaData.fromJson(value),
              ),
            )
          : <String, ChapterMetaData>{},
    );
  }
}

class VerseSearchResult extends BaseModel {
  final int id;
  final String uuid;
  final String text;
  final int verseNumber;
  final int pageNumber;
  final int chapterNumber;
  final int partNumber;
  final int part;
  final int chapter;
  final int narration;
  final String resultType;

  VerseSearchResult({
    required this.id,
    required this.uuid,
    required this.text,
    required this.verseNumber,
    required this.pageNumber,
    required this.chapterNumber,
    required this.partNumber,
    required this.part,
    required this.chapter,
    required this.narration,
    required this.resultType,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['text'] = text;
    data['verse_number'] = verseNumber;
    data['page_number'] = pageNumber;
    data['chapter_number'] = chapterNumber;
    data['part_number'] = partNumber;
    data['part'] = part;
    data['chapter'] = chapter;
    data['narration'] = narration;
    data['result_type'] = resultType;
    return data;
  }

  factory VerseSearchResult.fromJson(Map<String, dynamic> json) {
    return VerseSearchResult(
      id: json['id'],
      uuid: json['uuid'],
      text: json['text'],
      verseNumber: json['verse_number'],
      pageNumber: json['page_number'],
      chapterNumber: json['chapter_number'],
      partNumber: json['part_number'],
      part: json['part'],
      chapter: json['chapter'],
      narration: json['narration'],
      resultType: json['result_type'],
    );
  }
}
