import 'dart:convert';

class PushNotification {
  final String? contentType;
  final String? targetType;
  final String? targetName; // string, int
  final int? objectId;
  final int? notificationId;
  final int? roomId;

  PushNotification(
    this.contentType,
    this.targetType,
    this.targetName,
    this.objectId,
    this.notificationId,
    this.roomId,
  );

  PushNotification copyWith({
    String? contentType,
    String? targetType,
    String? targetName,
    int? objectId,
    int? notificationId,
  }) {
    return PushNotification(
      contentType ?? this.contentType,
      targetType ?? this.targetType,
      targetName ?? this.targetName,
      objectId ?? this.objectId,
      notificationId ?? this.notificationId,
      roomId ?? roomId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content_type': contentType,
      'target_type': targetType,
      'target_name': targetName,
      'object_id': objectId,
      'room_id': roomId,
    };
  }

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      map['content_type'] != null ? map['content_type'] as String : null,
      map['target_type'] != null ? map['target_type'] as String : null,
      map['target_name'] != null ? map['target_name'] as String : null,
      map['object_id'] != null
          ? (map['object_id'] is String
              ? int.tryParse(map['object_id'])
              : map['object_id'])
          : null,
      map['notification_id'] != null
          ? int.tryParse(map['notification_id']) as int
          : null,
      map['room_id'] != null ? int.parse(map['room_id']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PushNotification.fromJson(String source) =>
      PushNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PushNotification(contentType: $contentType, targetType: $targetType, targetName: $targetName, objectId: $objectId)';
  }

  @override
  bool operator ==(covariant PushNotification other) {
    if (identical(this, other)) return true;

    return other.contentType == contentType &&
        other.targetType == targetType &&
        other.targetName == targetName &&
        other.objectId == objectId;
  }

  @override
  int get hashCode {
    return contentType.hashCode ^
        targetType.hashCode ^
        targetName.hashCode ^
        objectId.hashCode;
  }
}
