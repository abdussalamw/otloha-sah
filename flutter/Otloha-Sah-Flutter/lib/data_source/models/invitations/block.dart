import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

class Block {
  final int id;
  final int blocker;
  final int blocked;
  final String blockerType;
  final String blockedType;
  Block({
    required this.id,
    required this.blocker,
    required this.blocked,
    required this.blockerType,
    required this.blockedType,
  });

  Block copyWith({
    int? id,
    int? blocker,
    int? blocked,
    String? blockerType,
    String? blockedType,
  }) {
    return Block(
      id: id ?? this.id,
      blocker: blocker ?? this.blocker,
      blocked: blocked ?? this.blocked,
      blockerType: blockerType ?? this.blockerType,
      blockedType: blockedType ?? this.blockedType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'blocker': blocker,
      'blocked': blocked,
      'blocker_type': blockerType,
      'blocked_type': blockedType,
    };
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      id: map['id'] as int,
      blocker: map['blocker'] as int,
      blocked: map['blocked'] as int,
      blockerType: map['blocker_type'] as String,
      blockedType: map['blocked_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Block.fromJson(String source) =>
      Block.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Block(id: $id, blocker: $blocker, blocked: $blocked, blockerType: $blockerType, blockedType: $blockedType)';
  }

  @override
  bool operator ==(covariant Block other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.blocker == blocker &&
        other.blocked == blocked &&
        other.blockerType == blockerType &&
        other.blockedType == blockedType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        blocker.hashCode ^
        blocked.hashCode ^
        blockerType.hashCode ^
        blockedType.hashCode;
  }
}

class BlockedUser {
  final int id;
  final BaseUser user;
  BlockedUser({
    required this.id,
    required this.user,
  });

  BlockedUser copyWith({
    int? id,
    BaseUser? user,
  }) {
    return BlockedUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profile_data': user.toMap(),
    };
  }

  factory BlockedUser.fromMap(Map<String, dynamic> map) {
    return BlockedUser(
      id: map['id'] as int,
      user: BaseUser.fromMap(map['profile_data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedUser.fromJson(String source) =>
      BlockedUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BlockedUser(id: $id, user: $user)';

  @override
  bool operator ==(covariant BlockedUser other) {
    if (identical(this, other)) return true;

    return other.id == id && other.user == user;
  }

  @override
  int get hashCode => id.hashCode ^ user.hashCode;
}
