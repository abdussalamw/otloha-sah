import 'dart:convert';

import 'fault.dart';
import '../record/record.dart';

/// id : 1
/// addressee : {"id":4,"first_name":"Benjamin","last_name":"Smith","level":"beginner","is_a_teacher":true,"narration_id":"1","image":"/media/users/2022/06/04/-avatar1_k9jheTV.png","teacher_type":"Volunteer"}
/// addresser : {"id":44,"username":"Shadyd","first_name":"","last_name":"","level":"beginner","is_a_teacher":false,"narration_id":"1","image":"/media/default/images/profile.png"}
/// is_read : false
/// read_at : ""
/// isSent : true
/// sentAt : "2022-04-07T12:50:04.191456Z"
/// recitation : {"id":205,"records":[{"id":205,"file":"/media/records/bb118773-7a5b-4e95-b3ac-33780ed41e5e/record-FilesGeneratedRecoed1649333030310.wav","wave":"/media/records/bb118773-7a5b-4e95-b3ac-33780ed41e5e/wave-1649333044592035.wave","created_at":"2022-04-07T12:04:06.088653Z"}],"narration_id":"1","verse_ids":"[1163]","owner":{"id":44,"username":"Shadyd","first_name":"","last_name":"","level":"beginner","is_a_teacher":false,"narration_id":"1","image":"/media/default/images/profile.png"},"chapter_id":"1","finished_at":"2022-04-07T12:50:04.183766Z","name":"ٱلَّذِينَ يُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقۡنَٰهُمۡ"}
/// replies : [""]

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));
String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  int id;
  int room;
  int? replyTo;
  String text;
  Record? record;
  int user;
  List<int> seenBy;
  bool isSent;
  String sentAt;
  Fault? fault;

  MessageModel({
    required this.id,
    required this.room,
    this.replyTo,
    required this.text,
    this.record,
    required this.user,
    required this.seenBy,
    required this.isSent,
    required this.sentAt,
    this.fault,
  });

  MessageModel copyWith({
    int? id,
    int? room,
    int? replyTo,
    String? text,
    Record? record,
    int? user,
    List<int>? seenBy,
    bool? isSent,
    String? sentAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      room: room ?? this.room,
      replyTo: replyTo ?? this.replyTo,
      text: text ?? this.text,
      record: record ?? this.record,
      user: user ?? this.user,
      seenBy: seenBy ?? this.seenBy,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room': room,
      'reply_to': replyTo,
      'text': text,
      'record': record,
      'user': user,
      'seen_by': seenBy,
      'is_sent': isSent,
      'sent_at': sentAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      room: map['room']?.toInt() ?? 0,
      replyTo: map['reply_to'],
      text: map['text'] ?? '',
      record: map['record'] != null ? Record.fromMap(map['record']) : null,
      user: map['user']?.toInt() ?? 0,
      seenBy: List<int>.from(map['seen_by']),
      isSent: map['is_sent'] ?? false,
      sentAt: map['sent_at'] ?? '',
      fault: map['fault'] != null ? Fault.fromMap(map['fault']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(room: $room, reply_to: $replyTo, text: $text, record: $record, user: $user, seen_by: $seenBy, isSent: $isSent, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel && other.id == id;
  }

  @override
  int get hashCode {
    return id;
  }
}
