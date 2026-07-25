import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';

class ReservedTimeslot {
  final int id;
  final String examType;
  final String status;
  final TimeSlot calendarSlot;
  final String? meetingLink;
  final String? notes;
  final TajweedLevel level;
  ReservedTimeslot({
    required this.id,
    required this.examType,
    required this.status,
    required this.calendarSlot,
    required this.level,
    this.meetingLink,
    this.notes,
  });

  ReservedTimeslot copyWith({
    int? id,
    String? examType,
    String? status,
    TimeSlot? calendarSlot,
    String? meetingLink,
    String? notes,
    TajweedLevel? level,
  }) {
    return ReservedTimeslot(
      id: id ?? this.id,
      examType: examType ?? this.examType,
      status: status ?? this.status,
      calendarSlot: calendarSlot ?? this.calendarSlot,
      meetingLink: meetingLink ?? this.meetingLink,
      notes: notes ?? this.notes,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'examType': examType,
      'status': status,
      'calendarSlot': calendarSlot.toJson(),
      'meetingLink': meetingLink,
      'notes': notes,
      'level': level.toMap(),
    };
  }

  factory ReservedTimeslot.fromMap(Map<String, dynamic> map) {
    return ReservedTimeslot(
      id: map['id'] as int,
      examType: map['exam_type'] as String,
      status: map['status'] as String,
      calendarSlot:
          TimeSlot.fromJson(map['calendar_slot'] as Map<String, dynamic>),
      meetingLink:
          map['meeting_link'] != null ? map['meeting_link'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      level: TajweedLevel.fromMap(map['level'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReservedTimeslot.fromJson(String source) =>
      ReservedTimeslot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReservedTimeslot(id: $id, examType: $examType, status: $status, calendarSlot: $calendarSlot, meetingLink: $meetingLink, notes: $notes, level: $level)';
  }

  @override
  bool operator ==(covariant ReservedTimeslot other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.examType == examType &&
        other.status == status &&
        other.calendarSlot == calendarSlot &&
        other.meetingLink == meetingLink &&
        other.notes == notes &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        examType.hashCode ^
        status.hashCode ^
        calendarSlot.hashCode ^
        meetingLink.hashCode ^
        notes.hashCode ^
        level.hashCode;
  }
}
