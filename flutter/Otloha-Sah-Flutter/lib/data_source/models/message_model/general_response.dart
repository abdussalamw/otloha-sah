import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../record/record.dart';

GeneralResponse generalResponseFromJson(String str) =>
    GeneralResponse.fromJson(json.decode(str));
String generalResponseToJson(GeneralResponse data) =>
    json.encode(data.toJson());

class GeneralResponse {
  GeneralResponse({
    this.id,
    this.narrationId,
    this.verseIds,
    this.chapterId,
    this.name,
    this.owner,
    this.isTeacherRecitation,
    this.finishedAt,
    this.isFinished,
    this.showInGeneral,
    this.archivedAt,
    this.gender,
    this.isChild,
    this.records,
    this.comments,
    this.likes,
    this.remarkable,
    this.canCreateMessage,
    this.sentTo,
    this.rate,
    this.isAccepted,
    this.acceptedAt,
    this.isRejected,
    this.rejectedAt,
    this.isReported,
    this.reportedAt,
    this.isRemarkable,
    this.markedAsRemarkableAt,
  });

  GeneralResponse.fromJson(dynamic json) {
    id = json['id'];
    narrationId = int.parse(json['narration_id'] ?? '0');
    verseIds = List<int>.from(jsonDecode(json['verse_ids']));
    chapterId = int.parse(json['chapter_id'] ?? '0');
    name = json['name'];
    owner = json['owner'];
    ownerData =
        json['owner_data'] != null ? User.fromJson(json['owner_data']) : null;
    isTeacherRecitation = json['is_teacher_recitation'];
    finishedAt = json['finished_at'];
    isFinished = json['is_finished'];
    showInGeneral = json['show_in_general'];
    archivedAt = json['archived_at'];
    gender = json['gender'];
    isChild = json['is_child'];
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records?.add(Record.fromJson(v));
      });
    }
    comments = json['comments'] != null ? json['comments'].cast<String>() : [];
    likes = json['likes'] != null ? json['likes'].cast<String>() : [];
    remarkable =
        json['remarkable'] != null ? json['remarkable'].cast<String>() : [];
    canCreateMessage = json['can_create_message'];
    sentTo = json['sent_to'] != null ? json['sent_to'].cast<String>() : [];
    rate = json['rate'];
    isAccepted = json['is_accepted'];
    acceptedAt = json['accepted_at'];
    isRejected = json['is_rejected'];
    rejectedAt = json['rejected_at'];
    isReported = json['is_reported'];
    reportedAt = json['reported_at'];
    isRemarkable = json['is_remarkable'];
    chapterName = json['chapterName'];
    narrationName = json['narrationName'];
    markedAsRemarkableAt = json['marked_as_remarkable_at'];
  }
  int? id;
  int? narrationId;
  String? narrationName;
  List<int>? verseIds;
  int? chapterId;
  String? chapterName;
  String? name;
  User? ownerData;
  int? owner;
  bool? isTeacherRecitation;
  String? finishedAt;
  bool? isFinished;
  bool? showInGeneral;
  String? archivedAt;
  String? gender;
  bool? isChild;
  List<Record>? records;
  List<String>? comments;
  List<String>? likes;
  List<String>? remarkable;
  bool? canCreateMessage;
  List<String>? sentTo;
  String? rate;
  bool? isAccepted;
  String? acceptedAt;
  bool? isRejected;
  String? rejectedAt;
  bool? isReported;
  String? reportedAt;
  bool? isRemarkable;
  String? markedAsRemarkableAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['narration_id'] = narrationId;
    map['verse_ids'] = verseIds;
    map['chapter_id'] = chapterId;
    map['name'] = name;
    map['owner'] = owner;
    map['is_teacher_recitation'] = isTeacherRecitation;
    map['finished_at'] = finishedAt;
    map['is_finished'] = isFinished;
    map['show_in_general'] = showInGeneral;
    map['archived_at'] = archivedAt;
    map['gender'] = gender;
    map['is_child'] = isChild;
    if (records != null) {
      map['records'] = records?.map((v) => v.toJson()).toList();
    }
    map['comments'] = comments;
    map['likes'] = likes;
    map['remarkable'] = remarkable;
    map['can_create_message'] = canCreateMessage;
    map['sent_to'] = sentTo;
    map['rate'] = rate;
    map['is_accepted'] = isAccepted;
    map['accepted_at'] = acceptedAt;
    map['is_rejected'] = isRejected;
    map['rejected_at'] = rejectedAt;
    map['is_reported'] = isReported;
    map['reported_at'] = reportedAt;
    map['is_remarkable'] = isRemarkable;
    map['marked_as_remarkable_at'] = markedAsRemarkableAt;
    return map;
  }
}
