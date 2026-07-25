import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation_quran_meta_data.dart';
import 'package:otloha_sah_flutter/data_source/models/record/record.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/repository/chapter_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/narration_repository.dart';
import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/verse.dart';

import '../../local/database/database/database.dart';

@UseRowClass(Recitation)
class Recitations extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get narrationId => text().nullable()();
  TextColumn get verseIds => text().nullable()();
  TextColumn get chapterId => text().nullable()();
  TextColumn get record => text().map(const RecordConverter()).nullable()();
  TextColumn get owner => text().map(const UserConverter()).nullable()();
  IntColumn get ownerId => integer().nullable()();
  TextColumn get teacher => text().map(const UserConverter()).nullable()();
  TextColumn get gender => text().nullable()();
  BoolColumn get isChild => boolean().nullable()();
  BoolColumn get isTeacherRecitation =>
      boolean().withDefault(const Constant(false)).nullable()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get finishedAt => text().nullable()();

  TextColumn get teacherRate => text().nullable()();
  RealColumn get ownerRate => real().nullable()();

  TextColumn get result => text().nullable()();
  TextColumn get archivedAt => text().nullable()();
  TextColumn get evaluatedAt => text().nullable()();
  TextColumn get closedAt => text().nullable()();
  BoolColumn get isRemarkable => boolean().nullable()();
  BoolColumn get conversationStarted => boolean().nullable()();
  BoolColumn get beingEvaluated => boolean().nullable()();
  BoolColumn get isClosed => boolean().nullable()();

  BoolColumn get showInGeneral => boolean().nullable()();
  BoolColumn get showInRemarkable => boolean().nullable()();
  BoolColumn get canCreateMessage => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Recitation implements Insertable<Recitation> {
  Recitation({
    required this.id,
    this.name,
    this.narrationId,
    this.verseIds,
    this.chapterId,
    this.record,
    this.gender,
    this.isChild,
    this.isTeacherRecitation,
    this.updatedAt,
    this.createdAt,
    this.teacherRate,
    this.result,
    this.finishedAt,
    this.archivedAt,
    this.isRemarkable,
    this.conversationStarted,
    this.beingEvaluated,
    this.evaluatedAt,
    this.isClosed,
    this.closedAt,
    this.showInGeneral,
    this.showInRemarkable,
    this.owner,
    this.teacher,
    this.ownerRate,
    this.canCreateMessage,
    this.localRecord,
    this.ownerId,
  });

  int id;
  String? name;
  String? narrationId;
  String? verseIds;
  String? chapterId;
  Record? record;
  String? gender;
  bool? isChild;
  bool? isTeacherRecitation;
  String? updatedAt;
  String? createdAt;
  String? teacherRate;
  String? result;
  String? finishedAt;
  String? archivedAt;
  bool? isRemarkable;
  bool? conversationStarted;
  bool? beingEvaluated;
  String? evaluatedAt;
  bool? isClosed;
  String? closedAt;
  bool? showInGeneral;
  bool? showInRemarkable;
  User? owner;
  int? ownerId;
  User? teacher;
  double? ownerRate;
  bool? canCreateMessage;
  String? localRecord;

  factory Recitation.fromJson(Map<String, dynamic> json) {
    return Recitation(
      id: json['id'],
      name: json['name'],
      narrationId: json['narration_id'],
      chapterId: json['chapter_id'],
      record: json['records'] != null && json['records'].isNotEmpty
          ? Record.fromMap(json['records'][0])
          : null,
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
      owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      gender: json['gender'],
      isChild: json['is_child'],
      isTeacherRecitation: json['is_teacher_recitation'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      teacherRate: json['teacher_rate'],
      result: json['result'],
      finishedAt: json['finished_at'],
      archivedAt: json['archived_at'],
      isRemarkable: json['is_remarkable'],
      conversationStarted: json['conversation_started'],
      beingEvaluated: json['being_evaluated'],
      evaluatedAt: json['evaluated_at'],
      isClosed: json['is_closed'],
      closedAt: json['closed_at'],
      showInGeneral: json['show_in_general'],
      showInRemarkable: json['show_in_remarkable'],
      ownerRate: double.parse(json['owner_rate']),
      canCreateMessage: json['can_create_message'],
      ownerId: json['owner'] != null ? User.fromJson(json['owner']).id : null,
      verseIds: json['verse_ids'],
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'narration_id': narrationId,
      'chapter_id': chapterId,
      'records': record != null ? [record?.toJson()] : null,
      'teacher': teacher?.toJson(),
      'owner': owner?.toJson(),
      'gender': gender,
      'is_child': isChild,
      'is_teacher_recitation': isTeacherRecitation,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'teacher_rate': teacherRate,
      'result': result,
      'finished_at': finishedAt,
      'archived_at': archivedAt,
      'is_remarkable': isRemarkable,
      'conversation_started': conversationStarted,
      'being_evaluated': beingEvaluated,
      'evaluated_at': evaluatedAt,
      'is_closed': isClosed,
      'closed_at': closedAt,
      'show_in_general': showInGeneral,
      'show_in_remarkable': showInRemarkable,
      'owner_rate': ownerRate,
      'can_create_message': canCreateMessage,
    };
  }

  Recitation copyWith({
    int? id,
    String? name,
    String? narrationId,
    String? verseIds,
    String? chapterId,
    Record? record,
    String? gender,
    bool? isChild,
    bool? isTeacherRecitation,
    String? updatedAt,
    String? createdAt,
    String? teacherRate,
    String? result,
    String? finishedAt,
    String? archivedAt,
    bool? isRemarkable,
    bool? conversationStarted,
    bool? beingEvaluated,
    String? evaluatedAt,
    bool? isClosed,
    String? closedAt,
    bool? showInGeneral,
    bool? showInRemarkable,
    User? owner,
    int? ownerId,
    User? teacher,
    double? ownerRate,
    bool? canCreateMessage,
    String? localRecord,
  }) {
    return Recitation(
      id: id ?? this.id,
      name: name ?? this.name,
      narrationId: narrationId ?? this.narrationId,
      verseIds: verseIds ?? this.verseIds,
      chapterId: chapterId ?? this.chapterId,
      record: record ?? this.record,
      gender: gender ?? this.gender,
      isChild: isChild ?? this.isChild,
      isTeacherRecitation: isTeacherRecitation ?? this.isTeacherRecitation,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      teacherRate: teacherRate ?? this.teacherRate,
      result: result ?? this.result,
      finishedAt: finishedAt ?? this.finishedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      isRemarkable: isRemarkable ?? this.isRemarkable,
      conversationStarted: conversationStarted ?? this.conversationStarted,
      beingEvaluated: beingEvaluated ?? this.beingEvaluated,
      evaluatedAt: evaluatedAt ?? this.evaluatedAt,
      isClosed: isClosed ?? this.isClosed,
      closedAt: closedAt ?? this.closedAt,
      showInGeneral: showInGeneral ?? this.showInGeneral,
      showInRemarkable: showInRemarkable ?? this.showInRemarkable,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      teacher: teacher ?? this.teacher,
      ownerRate: ownerRate ?? this.ownerRate,
      canCreateMessage: canCreateMessage ?? this.canCreateMessage,
      localRecord: localRecord ?? this.localRecord,
    );
  }

  List<int> getVerseList() {
    List<dynamic> decodedList = jsonDecode(verseIds!);
    return decodedList.map((element) => element as int).toList();
  }

  Future<RecitationQuranMetaData> getQuranMetaData() async {
    Chapter? chapter = await ChapterRepository()
        .fetchChapterById(int.parse(chapterId!), int.parse(narrationId ?? '0'));

    print(verseIds);
    List<Verse> verses = await VersesLocalDataSource()
        .findVersesBetween(getVerseList().first, getVerseList().last);

    print(verses);

    Narration? narration =
        await NarrationRepository().fetchNarrationById(int.parse(narrationId!));

    return RecitationQuranMetaData(chapter, verses, narration);
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return RecitationsCompanion(
      id: Value(id),
      name: Value(name),
      narrationId: Value(narrationId),
      chapterId: Value(chapterId),
      record: Value(record),
      teacher: Value(teacher),
      owner: Value(owner),
      gender: Value(gender),
      isChild: Value(isChild!),
      isTeacherRecitation: Value(isTeacherRecitation),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      teacherRate: Value(teacherRate),
      result: Value(result),
      finishedAt: Value(finishedAt),
      archivedAt: Value(archivedAt),
      isRemarkable: Value(isRemarkable),
      conversationStarted: Value(conversationStarted),
      beingEvaluated: Value(beingEvaluated),
      evaluatedAt: Value(evaluatedAt),
      isClosed: Value(isClosed),
      closedAt: Value(closedAt),
      showInGeneral: Value(showInGeneral),
      showInRemarkable: Value(showInRemarkable),
      ownerRate: Value(ownerRate),
      canCreateMessage: Value(canCreateMessage),
    ).toColumns(nullToAbsent);
  }
}
