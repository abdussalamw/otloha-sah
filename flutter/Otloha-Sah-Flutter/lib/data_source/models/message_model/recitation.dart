// import 'dart:convert';

// import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

// import 'record.dart';
// import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
// import 'package:quran_widget_flutter/quran_widget_flutter.dart';

// Recitation recitationFromJson(String str) =>
//     Recitation.fromJson(json.decode(str));
// String recitationToJson(Recitation data) => json.encode(data.toJson());

// class Recitation {
//   Recitation({
//     this.id,
//     this.name,
//     this.narrationId,
//     this.verseIds,
//     this.chapterId,
//     this.records,
//     this.owner,
//     this.teacher,
//     this.gender,
//     this.isChild,
//     this.isTeacherRecitation,
//     this.updatedAt,
//     this.createdAt,
//     this.rate,
//     this.result,
//     this.finishedAt,
//     this.archivedAt,
//     this.isRemarkable,
//     this.conversationStarted,
//     this.beingEvaluated,
//     this.evaluatedAt,
//     this.isClosed,
//     this.closedAt,
//     this.showInGeneral,
//     this.showInRemarkable,
//     this.chapter,
//     this.verses,
//     this.ownerData,
//     this.narration,
//     this.ownerRate,
//     this.canCreateMessage,
//     this.localRecord,
//   });

//   Recitation.fromJson(dynamic json) {
//     verseIds = json['verse_ids']
//         .substring(1, json['verse_ids'].length - 1)
//         .split(',')
//         .map<int>((id) => id.isNotEmpty ? int.parse(id) : 0)
//         .toList();

//     verseIds!.removeWhere((element) => element == 0);

//     id = json['id'];
//     name = json['name'];
//     narrationId = json['narration_id'];
//     chapterId = json['chapter_id'];
//     if (json['records'] != null) {
//       records = [];
//       json['records'].forEach((v) {
//         records?.add(Record.fromMap(v));
//       });
//     }
//     if (json['teacher'] != null && json['teacher']['id'] != null) {
//       teacher = json['teacher']['id'];
//     }
//     gender = json['gender'];
//     isChild = json['is_child'];
//     isTeacherRecitation = json['is_teacher_recitation'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     rate = json['teacher_rate'];
//     result = json['result'];
//     finishedAt = json['finished_at'];
//     archivedAt = json['archived_at'];
//     isRemarkable = json['is_remarkable'];
//     conversationStarted = json['conversation_started'];
//     beingEvaluated = json['being_evaluated'];
//     evaluatedAt = json['evaluated_at'];
//     isClosed = json['is_closed'];
//     closedAt = json['closed_at'];
//     showInGeneral = json['show_in_general'];
//     showInRemarkable = json['show_in_remarkable'];
//     ownerRate = double.parse(json['owner_rate']);
//     canCreateMessage = json['can_create_message'];
//     ownerData = json['owner'] != null ? User.fromJson(json['owner']) : null;
//     chapter =
//         ChapterRepository().fetchChapterById(int.parse(json['chapter_id']));
//     narration = NarrationRepository()
//         .fetchNarrationById(int.parse(json['narration_id']));
//     verses = verseIds!.isNotEmpty
//         ? VersesLocalDataSource()
//             .findVersesBetween(verseIds!.first, verseIds!.last)
//         : Future.value([]);
//   }

//   Recitation.fromDBJson(dynamic json, {String? localRecord, String? dirPath}) {
//     if (json['verse_ids'] != null && json['verse_ids'].isNotEmpty) {
//       verseIds = json['verse_ids']
//           .substring(1, json['verse_ids'].length - 1)
//           .split(',')
//           .map<int>((id) => id.isNotEmpty ? int.parse(id) : 0)
//           .toList();
//       verseIds!.removeWhere((element) => element == 0);
//     }

//     id = json['id'];
//     name = json['name'];
//     narrationId = json['narration_id'].toString();
//     chapterId = json['chapter_id'].toString();
//     this.localRecord = (dirPath ?? '') + (localRecord ?? json['local_record']);
//     // json['records'] = json.decode(json['records']);
//     // if (json['records'] != null) {
//     //   records = [];
//     //   json['records'].forEach((v) {
//     //     records?.add(Record.fromMap(v));
//     //   });
//     // }
//     if (json['teacher'] != null && json['teacher']['id'] != null) {
//       teacher = json['teacher']['id'];
//     }
//     gender = json['gender'];
//     isChild = json['is_child'] == 1;
//     isTeacherRecitation = json['is_teacher_recitation'] == 1;
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     rate = json['teacher_rate'];
//     result = json['result'];
//     finishedAt = json['finished_at'];
//     archivedAt = json['archived_at'];
//     isRemarkable = json['is_remarkable'] == 1;
//     conversationStarted = json['conversation_started'] == 1;
//     beingEvaluated = json['being_evaluated'] == 1;
//     evaluatedAt = json['evaluated_at'];
//     isClosed = json['is_closed'] == 1;
//     closedAt = json['closed_at'];
//     showInGeneral = json['show_in_general'] == 1;
//     showInRemarkable = json['show_in_remarkable'] == 1;
//     ownerRate = json['owner_rate'];
//     ownerData =
//         json['owner'] != null ? User.fromJson(jsonDecode(json['owner'])) : null;
//     if (json['chapter_id'] != null) {
//       chapter = ChapterRepository().fetchChapterById(
//           json['chapter_id'] is String
//               ? int.parse(json['chapter_id'])
//               : json['chapter_id']);
//     }
    // if (json['narration_id'] != null) {
    //   narration = NarrationRepository().fetchNarrationById(
    //       json['narration_id'] is String
    //           ? int.parse(json['narration_id'])
    //           : json['narration_id']);
    // }
    // if (verseIds != null) {
    //   verses = verseIds!.isNotEmpty
    //       ? VersesLocalDataSource()
    //           .findVersesBetween(verseIds!.first, verseIds!.last)
    //       : Future.value([]);
    // }
//   }
//   int? id;
//   String? name;
//   String? narrationId;
//   List<int>? verseIds;
//   String? chapterId;
//   List<Record>? records;
//   int? owner;
//   int? teacher;
//   String? gender;
//   bool? isChild;
//   bool? isTeacherRecitation;
//   String? updatedAt;
//   String? createdAt;
//   String? rate;
//   String? result;
//   String? finishedAt;
//   dynamic archivedAt;
//   bool? isRemarkable;
//   bool? conversationStarted;
//   bool? beingEvaluated;
//   String? evaluatedAt;
//   bool? isClosed;
//   dynamic closedAt;
//   bool? showInGeneral;
//   bool? showInRemarkable;
//   Future<Chapter?>? chapter;
//   Future<List<Verse>>? verses;
//   Future<Narration?>? narration;
//   User? ownerData;
//   double? ownerRate;
//   bool? canCreateMessage;
//   String? localRecord;

  // Future<RecitationQuranMetaData> getQuranMetaData() async {
  //   return RecitationQuranMetaData(
  //     await chapter,
  //     await verses,
  //     await narration,
  //   );
  // }

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['narration_id'] = narrationId;
//     map['verse_ids'] = verseIds;
//     map['chapter_id'] = chapterId;
//     if (records != null) {
//       map['records'] = records?.map((v) => v.toJson()).toList();
//     }
//     map['owner'] = owner;
//     map['teacher'] = teacher;
//     map['gender'] = gender;
//     map['is_child'] = isChild;
//     map['is_teacher_recitation'] = isTeacherRecitation;
//     map['updated_at'] = updatedAt;
//     map['created_at'] = createdAt;
//     map['teacher_rate'] = rate;
//     map['result'] = result;
//     map['finished_at'] = finishedAt;
//     map['archived_at'] = archivedAt;
//     map['is_remarkable'] = isRemarkable;
//     map['conversation_started'] = conversationStarted;
//     map['being_evaluated'] = beingEvaluated;
//     map['evaluated_at'] = evaluatedAt;
//     map['is_closed'] = isClosed;
//     map['closed_at'] = closedAt;
//     map['show_in_general'] = showInGeneral;
//     map['show_in_remarkable'] = showInRemarkable;
//     map['owner_data'] = ownerData?.toJson();
//     return map;
//   }

//   Map<String, dynamic> toDBJson({String? localRecord}) {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['narration_id'] = narrationId;
//     map['verse_ids'] = json.encode(verseIds);
//     map['chapter_id'] = chapterId;
//     if (records != null) {
//       map['records'] = jsonEncode(records?.map((v) => v.toJson()).toList());
//     }
//     map['local_record'] = localRecord ?? this.localRecord;
//     map['owner'] = json.encode(ownerData?.toJson());
//     map['gender'] = gender;
//     map['is_child'] = (isChild ?? false) ? 1 : 0;
//     map['is_teacher_recitation'] = (isTeacherRecitation ?? false) ? 1 : 0;
//     map['updated_at'] = updatedAt;
//     map['created_at'] = createdAt;
//     map['rate'] = rate;
//     map['result'] = result;
//     map['is_remarkable'] = (isRemarkable ?? false) ? 1 : 0;
//     map['conversation_started'] = (conversationStarted ?? false) ? 1 : 0;
//     map['being_evaluated'] = (beingEvaluated ?? false) ? 1 : 0;
//     map['evaluated_at'] = evaluatedAt;
//     map['is_closed'] = (isClosed ?? false) ? 1 : 0;
//     map['closed_at'] = closedAt;
//     map['show_in_general'] = (showInGeneral ?? false) ? 1 : 0;
//     map['show_in_remarkable'] = (showInRemarkable ?? false) ? 1 : 0;
//     map['user_id'] = ownerData?.id;
//     return map;
//   }

//   Recitation copyWith({
//     int? id,
//     String? name,
//     String? narrationId,
//     List<int>? verseIds,
//     String? chapterId,
//     List<Record>? records,
//     int? owner,
//     int? teacher,
//     String? gender,
//     bool? isChild,
//     bool? isTeacherRecitation,
//     String? updatedAt,
//     String? createdAt,
//     String? rate,
//     String? result,
//     String? finishedAt,
//     dynamic archivedAt,
//     bool? isRemarkable,
//     bool? conversationStarted,
//     bool? beingEvaluated,
//     String? evaluatedAt,
//     bool? isClosed,
//     dynamic closedAt,
//     bool? showInGeneral,
//     bool? showInRemarkable,
//     Future<Chapter?>? chapter,
//     Future<List<Verse>>? verses,
//     Future<Narration?>? narration,
//     User? ownerData,
//     double? ownerRate,
//   }) {
//     return Recitation(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       narrationId: narrationId ?? this.narrationId,
//       verseIds: verseIds ?? this.verseIds,
//       chapterId: chapterId ?? this.chapterId,
//       records: records ?? this.records,
//       owner: owner ?? this.owner,
//       teacher: teacher ?? this.teacher,
//       gender: gender ?? this.gender,
//       isChild: isChild ?? this.isChild,
//       isTeacherRecitation: isTeacherRecitation ?? this.isTeacherRecitation,
//       updatedAt: updatedAt ?? this.updatedAt,
//       createdAt: createdAt ?? this.createdAt,
//       rate: rate ?? this.rate,
//       result: result ?? this.result,
//       finishedAt: finishedAt ?? this.finishedAt,
//       archivedAt: archivedAt ?? this.archivedAt,
//       isRemarkable: isRemarkable ?? this.isRemarkable,
//       conversationStarted: conversationStarted ?? this.conversationStarted,
//       beingEvaluated: beingEvaluated ?? this.beingEvaluated,
//       evaluatedAt: evaluatedAt ?? this.evaluatedAt,
//       isClosed: isClosed ?? this.isClosed,
//       closedAt: closedAt ?? this.closedAt,
//       showInGeneral: showInGeneral ?? this.showInGeneral,
//       showInRemarkable: showInRemarkable ?? this.showInRemarkable,
//       chapter: chapter ?? this.chapter,
//       verses: verses ?? this.verses,
//       narration: narration ?? this.narration,
//       ownerData: ownerData ?? this.ownerData,
//       ownerRate: ownerRate ?? this.ownerRate,
//       canCreateMessage: canCreateMessage ?? canCreateMessage,
//     );
//   }
// }

// class RecitationQuranMetaData {
//   final Chapter? chapter;
//   final List<Verse>? verses;
//   final Narration? narration;

//   RecitationQuranMetaData(this.chapter, this.verses, this.narration);
// }
