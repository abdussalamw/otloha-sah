import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

class InvitationRecieved {
  final int id;
  final String invitationType;
  final String status;
  final BaseUser requester;
  InvitationRecieved({
    required this.id,
    required this.invitationType,
    required this.status,
    required this.requester,
  });

  InvitationRecieved copyWith({
    int? id,
    String? invitationType,
    String? status,
    BaseUser? requester,
  }) {
    return InvitationRecieved(
      id: id ?? this.id,
      invitationType: invitationType ?? this.invitationType,
      status: status ?? this.status,
      requester: requester ?? this.requester,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'invitationType': invitationType,
      'status': status,
      'baseUser': requester.toMap(),
    };
  }

  factory InvitationRecieved.fromMap(Map<String, dynamic> map) {
    return InvitationRecieved(
      id: map['id'] as int,
      invitationType: map['invitation_type'] as String,
      status: 'pending',
      requester:
          BaseUser.fromMap(map['requester_data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory InvitationRecieved.fromJson(String source) =>
      InvitationRecieved.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvitationRecieved(id: $id, invitationType: $invitationType, status: $status)';
  }

  @override
  bool operator ==(covariant InvitationRecieved other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.invitationType == invitationType &&
        other.status == status &&
        other.requester == requester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        invitationType.hashCode ^
        status.hashCode ^
        requester.hashCode;
  }
}
