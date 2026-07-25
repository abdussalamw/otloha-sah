import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/notifications_model/sender.dart';

class NotificationsModel {
  final int id;
  final String text;
  final Sender? user;
  final String contentType;
  final int objectId;
  final String? targetName;
  final String createdAt;
  final bool isSeen;
  final String targetType;
  final bool isRead;
  final int? roomId;

  NotificationsModel({
    required this.id,
    required this.text,
    required this.user,
    required this.contentType,
    required this.objectId,
    required this.createdAt,
    required this.isSeen,
    required this.targetType,
    required this.isRead,
    required this.targetName,
    this.roomId,
  });

  NotificationsModel copyWith({
    int? id,
    String? text,
    Sender? user,
    String? contentType,
    int? objectId,
    String? createdAt,
    bool? isSeen,
    String? targetType,
    bool? isRead,
    String? targetName,
  }) {
    return NotificationsModel(
      id: id ?? this.id,
      text: text ?? this.text,
      user: user ?? this.user,
      contentType: contentType ?? this.contentType,
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      isSeen: isSeen ?? this.isSeen,
      targetType: targetType ?? this.targetType,
      isRead: isRead ?? this.isRead,
      targetName: targetName ?? this.targetName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'user': user?.toJson(),
      'content_type': contentType,
      'object_id': objectId,
      'created_at': createdAt,
      'is_seen': isSeen,
      'target_type': targetType,
      'is_read': isRead,
      'target_name': targetName,
      'room_id': roomId,
    };
  }

  Map<String, dynamic> toPushNotificationMap() {
    return {
      'content_type': contentType,
      'object_id': objectId,
      'target_type': targetType,
      'target_name': targetName,
      'room_id': roomId,
    };
  }

  factory NotificationsModel.fromMap(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id']?.toInt() ?? 0,
      text: map['text'] ?? '',
      user: map['sender'] != null ? Sender.fromMap(map['sender']) : null,
      contentType: map['content_type'] ?? '',
      objectId: map['object_id']?.toInt() ?? 0,
      createdAt: map['created_at'] ?? '',
      isSeen: map['is_seen'] ?? false,
      targetType: map['target_type'] ?? '',
      isRead: map['is_read'] ?? false,
      targetName: map['template_name'],
      roomId: map['room_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationsModel.fromJson(String source) =>
      NotificationsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationsModel(id: $id, text: $text, user: $user, contentType: $contentType, objectId: $objectId, createdAt: $createdAt, isSeen: $isSeen, targetType: $targetType, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationsModel &&
        other.id == id &&
        other.text == text &&
        other.user == user &&
        other.contentType == contentType &&
        other.objectId == objectId &&
        other.createdAt == createdAt &&
        other.isSeen == isSeen &&
        other.targetType == targetType &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        user.hashCode ^
        contentType.hashCode ^
        objectId.hashCode ^
        createdAt.hashCode ^
        isSeen.hashCode ^
        targetType.hashCode ^
        isRead.hashCode;
  }
}
