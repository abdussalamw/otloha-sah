import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';
import 'package:quran_widget_flutter/model/chapters_page.dart';
import 'package:quran_widget_flutter/model/glyph.dart';
import 'package:quran_widget_flutter/model/verse.dart';

/*
 foreignKeys: [
 // ForeignKey( childColumns: ['narration'], parentColumns: ['id'], entity: Narration),
  //ForeignKey(childColumns: ['chapter'], parentColumns: ['id'], entity: Chapter),
 // ForeignKey(childColumns: ['book'], parentColumns: ['id'], entity: Book),
  //ForeignKey(childColumns: ['part'], parentColumns: ['id'], entity: Part),
]
 */

@Entity(
  tableName: 'Page',
)
class Page extends BaseModel {
  @primaryKey
  int? id;
  @ColumnInfo(name: 'page_number')
  int? pageNumber;
  @ColumnInfo(name: 'narration')
  int? narrationId;
  @ColumnInfo(name: 'book')
  int? bookId;
  @ColumnInfo(name: 'part')
  int? partId;
  @ColumnInfo(name: 'sub_part')
  int? subPartId;
  String? image;
  String? localImage;
  @ColumnInfo(name: 'chapters')
  String chaptersId;

  @ignore
  List<Verse>? verses;
  @ignore
  List<Glyph>? glyphs;
  @ignore
  List<ChaptersPage>? chapters;

  Page({
    this.id,
    this.pageNumber,
    this.narrationId,
    this.bookId,
    this.partId,
    this.subPartId,
    this.image,
    this.localImage,
    this.verses,
    this.glyphs,
    this.chapters,
    required this.chaptersId,
  });

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['page_number'] = pageNumber;
    data['narration'] = narrationId;
    data['book'] = bookId;
    data['part'] = partId;
    data['sub_part'] = subPartId;
    data['image'] = image;
    if (verses != null) {
      data['verses'] = verses!.map((v) => v.toJson()).toList();
    }
    if (glyphs != null) {
      data['glyphs'] = glyphs!.map((v) => v.toJson()).toList();
    }
    if (glyphs != null) {
      data['chapters'] = chapters!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory Page.fromJson(Map<String, dynamic> map) {
    print('Start fromJson map');

    List<Verse>? verses;
    List<Glyph>? glyphs;
    List<ChaptersPage>? chaptersPage;
    int chapter = 0;

    if (map['verses'] != null) {
      verses = <Verse>[];
      map['verses'].forEach((v) {
        verses!.add(Verse.fromJson(v));
      });
    }
    if (map['glyphs'] != null) {
      glyphs = <Glyph>[];
      map['glyphs'].forEach((v) {
        glyphs!.add(Glyph.fromJson(v));
      });
    }

    try {
      if (map['chapters'] != null) {
        chaptersPage = <ChaptersPage>[];

        map['chapters'].forEach((v) {
          chapter = (v as int);
          chaptersPage!.add(ChaptersPage(
            chapterId: chapter,
            pageId: map['id']?.toInt(),
          ));
        });
      }
    } catch (e) {
      print('Error FromJson' + e.toString());
    }

    return Page(
        id: map['id']?.toInt(),
        pageNumber: map['page_number']?.toInt(),
        narrationId: map['narration']?.toInt(),
        bookId: map['book']?.toInt(),
        partId: map['part']?.toInt(),
        subPartId: map['sub_part']?.toInt(),
        image: map['image'],
        localImage: map['localImage'],
        chaptersId: json.encode(map['chapters'] ?? ''),
        verses: verses,
        glyphs: glyphs,
        chapters: chaptersPage);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Page && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return 'Page(id: $id, pageNumber: $pageNumber, narrationId: $narrationId, bookId: $bookId, partId: $partId, subPartId: $subPartId, image: $image, localImage: $localImage,  chapters: $chaptersId)';
  }

  List get getchaptersId {
    return json.decode(chaptersId) as List;
  }
}
