import 'dart:convert';

class Invitations {
  final int? outJoinEntityRequest;
  final int? inJoinEntityRequest;

  final int? outFriendRequest;
  final int? inFriendRequest;

  final int? outSupervisionRequest;
  final int? inSupervisionRequest;
  Invitations({
    required this.outJoinEntityRequest,
    required this.inJoinEntityRequest,
    required this.outFriendRequest,
    required this.inFriendRequest,
    required this.outSupervisionRequest,
    required this.inSupervisionRequest,
  });

  Invitations copyWith({
    int? outJoinEntityRequest,
    int? inJoinEntityRequest,
    int? outFriendRequest,
    int? inFriendRequest,
    int? outSupervisionRequest,
    int? inSupervisionRequest,
  }) {
    print(outSupervisionRequest);
    return Invitations(
      outJoinEntityRequest: outJoinEntityRequest ?? this.outJoinEntityRequest,
      inJoinEntityRequest: inJoinEntityRequest ?? this.inJoinEntityRequest,
      outFriendRequest: outFriendRequest ?? this.outFriendRequest,
      inFriendRequest: inFriendRequest ?? this.inFriendRequest,
      outSupervisionRequest:
          outSupervisionRequest ?? this.outSupervisionRequest,
      inSupervisionRequest: inSupervisionRequest ?? this.inSupervisionRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'out_join_entity_request': outJoinEntityRequest,
      'in_join_entity_request': inJoinEntityRequest,
      'out_friend_request': outFriendRequest,
      'in_friend_request': inFriendRequest,
      'out_supervision_request': outSupervisionRequest,
      'in_supervision_request': inSupervisionRequest,
    };
  }

  factory Invitations.fromMap(Map<String, dynamic> map) {
    return Invitations(
      outJoinEntityRequest: map['out_join_entity_request'],
      inJoinEntityRequest: map['in_join_entity_request'],
      outFriendRequest: map['out_friend_request'],
      inFriendRequest: map['in_friend_request'],
      outSupervisionRequest: map['out_supervision_request'],
      inSupervisionRequest: map['in_supervision_request'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Invitations.fromJson(String source) =>
      Invitations.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invitations(outJoinEntityRequest: $outJoinEntityRequest, inJoinEntityRequest: $inJoinEntityRequest, outFriendRequest: $outFriendRequest, inFriendRequest: $inFriendRequest, outSupervisionRequest: $outSupervisionRequest, inSupervisionRequest: $inSupervisionRequest)';
  }

  @override
  bool operator ==(covariant Invitations other) {
    if (identical(this, other)) return true;

    return other.outJoinEntityRequest == outJoinEntityRequest &&
        other.inJoinEntityRequest == inJoinEntityRequest &&
        other.outFriendRequest == outFriendRequest &&
        other.inFriendRequest == inFriendRequest &&
        other.outSupervisionRequest == outSupervisionRequest &&
        other.inSupervisionRequest == inSupervisionRequest;
  }

  @override
  int get hashCode {
    return outJoinEntityRequest.hashCode ^
        inJoinEntityRequest.hashCode ^
        outFriendRequest.hashCode ^
        inFriendRequest.hashCode ^
        outSupervisionRequest.hashCode ^
        inSupervisionRequest.hashCode;
  }
}
