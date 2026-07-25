import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../message_model/message_model.dart';
import '../message_model/recitation.dart';
import '../record/record.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));
String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room({
    required this.id,
    required this.uuid,
    this.name,
    required this.roomType,
    required this.isClosed,
    required this.createdAt,
    this.updatedAt,
    required this.isGroupRoom,
    this.lastMessage,
    required this.unseenMessagesCount,
    required this.peers,
    required this.owner,
    required this.users,
    required this.seenBy,
    this.recitation,
    this.messages,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<User> users = [];
    if (json['users'] != null) {
      json['users'].forEach((v) {
        users.add(User.fromJson(v));
      });
    }

    List<int> seenBy = [];
    if (json['seen_by'] != null) {
      json['seen_by'].forEach((v) {
        seenBy.add(v);
      });
    }
    return Room(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      roomType: json['room_type'],
      isClosed: json['is_closed'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isGroupRoom: json['is_group_room'],
      lastMessage: json['last_message'] != null
          ? LastMessage.fromMap(json['last_message'])
          : null,
      unseenMessagesCount: json['unseen_messages_count'],
      peers: json['peers'].cast<int>(),
      owner: User.fromJson(json['owner']),
      users: users,
      seenBy: seenBy,
      recitation: json['recitation'] != null
          ? Recitation.fromJson(json['recitation'])
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((i) => MessageModel.fromMap(i))
              .toList()
          : null,
    );
  }
  int id;
  String uuid;
  String? name;
  String roomType;
  bool isClosed;
  String createdAt;
  String? updatedAt;
  bool isGroupRoom;
  LastMessage? lastMessage;
  int unseenMessagesCount;
  List<int> peers;
  User owner;
  List<User> users;
  List<int> seenBy;
  Recitation? recitation;
  List<MessageModel>? messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['name'] = name;
    map['room_type'] = roomType;
    map['is_closed'] = isClosed;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_group_room'] = isGroupRoom;
    if (lastMessage != null) {
      map['last_message'] = lastMessage?.toJson();
    }
    map['unseen_messages_count'] = unseenMessagesCount;
    map['peers'] = peers;
    map['owner'] = owner.toJson();
    map['users'] = users.map((v) => v.toJson()).toList();
    map['seen_by'] = seenBy.map((v) => v).toList();
    if (recitation != null) {
      map['recitation'] = recitation?.toJson();
    }
    return map;
  }

  Room copyWith({
    int? id,
    String? uuid,
    String? name,
    String? roomType,
    bool? isClosed,
    String? createdAt,
    String? updatedAt,
    bool? isGroupRoom,
    LastMessage? lastMessage,
    int? unseenMessagesCount,
    List<int>? peers,
    User? owner,
    List<User>? users,
    List<int>? seenBy,
    Recitation? recitation,
  }) {
    return Room(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      roomType: roomType ?? this.roomType,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGroupRoom: isGroupRoom ?? this.isGroupRoom,
      lastMessage: lastMessage ?? this.lastMessage,
      unseenMessagesCount: unseenMessagesCount ?? this.unseenMessagesCount,
      peers: peers ?? this.peers,
      owner: owner ?? this.owner,
      users: users ?? this.users,
      seenBy: seenBy ?? this.seenBy,
      recitation: recitation ?? this.recitation,
    );
  }
}

LastMessage lastMessageFromJson(String str) =>
    LastMessage.fromJson(json.decode(str));
String lastMessageToJson(LastMessage data) => json.encode(data.toJson());

class LastMessage {
  int room;
  int? replyTo;
  String? text;
  Record? record;
  int user;
  List<int> seenBy;
  bool isSent;
  String? sentAt;

  LastMessage({
    required this.room,
    this.replyTo,
    this.text,
    this.record,
    required this.user,
    required this.seenBy,
    required this.isSent,
    this.sentAt,
  });

  LastMessage copyWith({
    int? room,
    int? replyTo,
    String? text,
    Record? record,
    int? user,
    List<int>? seenBy,
    bool? isSent,
    String? sentAt,
  }) {
    return LastMessage(
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

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      room: map['room']?.toInt() ?? 0,
      replyTo: map['reply_to']?.toInt(),
      text: map['text'],
      record: map['record'] != null ? Record.fromMap(map['record']) : null,
      user: map['user']?.toInt() ?? 0,
      seenBy: List<int>.from(map['seen_by']),
      isSent: map['is_sent'] ?? false,
      sentAt: map['sent_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LastMessage.fromJson(String source) =>
      LastMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LastMessage(room: $room, reply_to: $replyTo, text: $text, record: $record, user: $user, seen_by: $seenBy, is_sent: $isSent, sent_at: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LastMessage &&
        other.room == room &&
        other.replyTo == replyTo &&
        other.text == text &&
        other.record == record &&
        other.user == user &&
        listEquals(other.seenBy, seenBy) &&
        other.isSent == isSent &&
        other.sentAt == sentAt;
  }

  @override
  int get hashCode {
    return room.hashCode ^
        replyTo.hashCode ^
        text.hashCode ^
        record.hashCode ^
        user.hashCode ^
        seenBy.hashCode ^
        isSent.hashCode ^
        sentAt.hashCode;
  }
}

// getInfo(Recitation? recitation) {
//   return 'سورة ${recitation?.chapterName ?? "البقرة"} ${(recitation?.verseIds != null && (recitation?.verseIds?.isNotEmpty ?? false)) ? "الأيه ${recitation?.verseIds?.first} " : ""} ${(recitation?.verseIds != null && (recitation?.verseIds?.isNotEmpty ?? false) && recitation?.verseIds?.first != recitation?.verseIds?.last) ? " الي ${recitation?.verseIds?.last}" : ""}';
// }
//سورة البقرة الأيه 6