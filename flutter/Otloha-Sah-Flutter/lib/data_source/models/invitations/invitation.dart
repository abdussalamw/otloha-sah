import 'dart:convert';

class Invitation {
  final int id;
  final String invitationType;
  final String status;
  final int? requestee;
  final int? requester;
  Invitation({
    required this.id,
    required this.invitationType,
    required this.status,
    this.requestee,
    this.requester,
  });

  Invitation copyWith({
    int? id,
    String? invitationType,
    String? status,
    int? requestee,
    int? requester,
  }) {
    return Invitation(
      id: id ?? this.id,
      invitationType: invitationType ?? this.invitationType,
      status: status ?? this.status,
      requestee: requestee ?? this.requestee,
      requester: requester ?? this.requester,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'invitation_type': invitationType,
      'status': status,
      'requestee': requestee,
      'requester': requester,
    };
  }

  factory Invitation.fromMap(Map<String, dynamic> map) {
    return Invitation(
      id: map['id'] as int,
      invitationType: map['invitation_type'] as String,
      status: 'pending',
      requestee: map['requestee'] != null ? map['requestee'] as int : null,
      requester: map['requester'] != null ? map['requester'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Invitation.fromJson(String source) =>
      Invitation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invitation(id: $id, invitationType: $invitationType, status: $status, requestee: $requestee, requester: $requester)';
  }

  @override
  bool operator ==(covariant Invitation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.invitationType == invitationType &&
        other.status == status &&
        other.requestee == requestee &&
        other.requester == requester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        invitationType.hashCode ^
        status.hashCode ^
        requestee.hashCode ^
        requester.hashCode;
  }
}
