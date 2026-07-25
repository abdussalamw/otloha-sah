import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

import 'addresser.dart';
import 'relpay.dart';

class MessageDelails {
  int? id;
  Addressee? addressee;
  Addressee? addresser;
  bool? isRead;
  String? readAt;
  bool? isSent;
  String? sentAt;
  Recitation? recitation;
  List<Reply>? replies;
  MessageDelails({
    this.id,
    this.addressee,
    this.addresser,
    this.isRead,
    this.readAt,
    this.isSent,
    this.sentAt,
    this.recitation,
    this.replies,
  });

  MessageDelails copyWith({
    int? id,
    Addressee? addressee,
    Addressee? addresser,
    bool? isRead,
    String? readAt,
    bool? isSent,
    String? sentAt,
    Recitation? recitation,
    List<Reply>? replies,
  }) {
    return MessageDelails(
      id: id ?? this.id,
      addressee: addressee ?? this.addressee,
      addresser: addresser ?? this.addresser,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
      recitation: recitation ?? this.recitation,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (addressee != null) {
      result.addAll({'addressee': addressee!.toJson()});
    }
    if (addresser != null) {
      result.addAll({'addresser': addresser!.toJson()});
    }
    if (isRead != null) {
      result.addAll({'isRead': isRead});
    }
    if (readAt != null) {
      result.addAll({'readAt': readAt});
    }
    if (isSent != null) {
      result.addAll({'isSent': isSent});
    }
    if (sentAt != null) {
      result.addAll({'sentAt': sentAt});
    }
    if (recitation != null) {
      result.addAll({'recitation': recitation!.toJson()});
    }
    if (replies != null) {
      result.addAll({'replies': replies!.map((x) => x.toJson()).toList()});
    }

    return result;
  }

  factory MessageDelails.fromMap(Map<String, dynamic> map) {
    return MessageDelails(
      id: map['id']?.toInt(),
      addressee: map['addressee'] != null
          ? Addressee.fromJson(map['addressee'])
          : null,
      addresser: map['addresser'] != null
          ? Addressee.fromJson(map['addresser'])
          : null,
      isRead: map['is_sead'],
      readAt: map['read_at'],
      isSent: map['is_sent'],
      sentAt: map['sent_at'],
      recitation: map['recitation'] != null
          ? Recitation.fromJson(map['recitation'])
          : null,
      replies: map['replies'] != null
          ? List<Reply>.from(map['replies']?.map((x) => Reply.fromJson(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageDelails.fromJson(String source) =>
      MessageDelails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageDelails(id: $id, addressee: $addressee, addresser: $addresser, isRead: $isRead, readAt: $readAt, isSent: $isSent, sentAt: $sentAt, recitation: $recitation, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageDelails &&
        other.id == id &&
        other.addressee == addressee &&
        other.addresser == addresser &&
        other.isRead == isRead &&
        other.readAt == readAt &&
        other.isSent == isSent &&
        other.sentAt == sentAt &&
        other.recitation == recitation &&
        listEquals(other.replies, replies);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addressee.hashCode ^
        addresser.hashCode ^
        isRead.hashCode ^
        readAt.hashCode ^
        isSent.hashCode ^
        sentAt.hashCode ^
        recitation.hashCode ^
        replies.hashCode;
  }
}
