import 'dart:convert';

import 'package:floor/floor.dart';

@Entity(tableName: 'ChaptersPage')
class ChaptersPage {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? pageId;
  int? chapterId;
  ChaptersPage({
    this.id,
    this.pageId,
    this.chapterId,
  });

  ChaptersPage copyWith({
    int? id,
    int? pageId,
    int? chapterId,
  }) {
    return ChaptersPage(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      chapterId: chapterId ?? this.chapterId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'chapterId': chapterId,
    };
  }

  factory ChaptersPage.fromMap(Map<String, dynamic> map) {
    return ChaptersPage(
      id: map['id']?.toInt(),
      pageId: map['pageId']?.toInt(),
      chapterId: map['chapterId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChaptersPage.fromJson(String source) =>
      ChaptersPage.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChaptersPage(id: $id, pageId: $pageId, chapterId: $chapterId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChaptersPage &&
        other.id == id &&
        other.pageId == pageId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode => id.hashCode ^ pageId.hashCode ^ chapterId.hashCode;
}
