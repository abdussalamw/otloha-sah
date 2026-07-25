import 'dart:convert';

import 'package:floor/floor.dart';

@Entity(tableName: 'ChapterDownload')
class ChapterDownload {
  @PrimaryKey(autoGenerate: true)
  int? id;

  int? narrationId;
  int? reciterId;
  int? recitationId;
  int? chapterId;
  bool downloaded;

  ChapterDownload({
    this.id,
    this.narrationId,
    this.reciterId,
    this.recitationId,
    this.chapterId,
    this.downloaded = false,
  });

  ChapterDownload copyWith({
    int? id,
    int? narrationId,
    int? reciterId,
    int? recitationId,
    int? chapterId,
    bool? downloaded,
  }) {
    return ChapterDownload(
      id: id ?? this.id,
      narrationId: narrationId ?? this.narrationId,
      reciterId: reciterId ?? this.reciterId,
      recitationId: recitationId ?? this.recitationId,
      chapterId: chapterId ?? this.chapterId,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'narrationId': narrationId,
      'reciterId': reciterId,
      'recitationId': recitationId,
      'chapterId': chapterId,
      'downloaded': downloaded,
    };
  }

  factory ChapterDownload.fromMap(Map<String, dynamic> map) {
    return ChapterDownload(
      id: map['id']?.toInt(),
      narrationId: map['narrationId']?.toInt(),
      reciterId: map['reciterId']?.toInt(),
      recitationId: map['recitationId']?.toInt(),
      chapterId: map['chapterId']?.toInt(),
      downloaded: map['downloaded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChapterDownload.fromJson(String source) =>
      ChapterDownload.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChapterDownload(id: $id, narrationId: $narrationId, reciterId: $reciterId, recitationId: $recitationId, chapterId: $chapterId, downloaded: $downloaded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterDownload &&
        other.id == id &&
        other.narrationId == narrationId &&
        other.reciterId == reciterId &&
        other.recitationId == recitationId &&
        other.chapterId == chapterId &&
        other.downloaded == downloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        narrationId.hashCode ^
        reciterId.hashCode ^
        recitationId.hashCode ^
        chapterId.hashCode ^
        downloaded.hashCode;
  }
}
