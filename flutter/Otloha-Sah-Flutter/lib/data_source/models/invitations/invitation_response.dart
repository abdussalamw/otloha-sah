import 'dart:convert';

class InvitationResponse {
  final int id;
  final int requester;
  final String requesterType;
  final int requestee;
  final String requesteeType;
  final String invitationType;
  final String status;
  InvitationResponse({
    required this.id,
    required this.requester,
    required this.requesterType,
    required this.requestee,
    required this.requesteeType,
    required this.invitationType,
    required this.status,
  });

  InvitationResponse copyWith({
    int? id,
    int? requester,
    String? requesterType,
    int? requestee,
    String? requesteeType,
    String? invitationType,
    String? status,
  }) {
    return InvitationResponse(
      id: id ?? this.id,
      requester: requester ?? this.requester,
      requesterType: requesterType ?? this.requesterType,
      requestee: requestee ?? this.requestee,
      requesteeType: requesteeType ?? this.requesteeType,
      invitationType: invitationType ?? this.invitationType,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'requester': requester,
      'requester_type': requesterType,
      'requestee': requestee,
      'requestee_type': requesteeType,
      'invitation_type': invitationType,
      'status': status,
    };
  }

  factory InvitationResponse.fromMap(Map<String, dynamic> map) {
    return InvitationResponse(
      id: map['id'] as int,
      requester: map['requester'] as int,
      requesterType: map['requester_type'] as String,
      requestee: map['requestee'] as int,
      requesteeType: map['requestee_type'] as String,
      invitationType: map['invitation_type'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvitationResponse.fromJson(String source) =>
      InvitationResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvitationResponse(id: $id, requester: $requester, requesterType: $requesterType, requestee: $requestee, requestee_type: $requesteeType, invitationType: $invitationType, status: $status)';
  }

  @override
  bool operator ==(covariant InvitationResponse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.requester == requester &&
        other.requesterType == requesterType &&
        other.requestee == requestee &&
        other.requesteeType == requesteeType &&
        other.invitationType == invitationType &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        requester.hashCode ^
        requesterType.hashCode ^
        requestee.hashCode ^
        requesteeType.hashCode ^
        invitationType.hashCode ^
        status.hashCode;
  }
}
