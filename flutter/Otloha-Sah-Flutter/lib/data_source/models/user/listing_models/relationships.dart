import 'dart:convert';

class Relationships {
  final bool memberInEntity;
  final bool supervision;
  final bool friend;
  Relationships({
    required this.memberInEntity,
    required this.supervision,
    required this.friend,
  });

  Relationships copyWith({
    bool? memberInEntity,
    bool? supervision,
    bool? friend,
  }) {
    return Relationships(
      memberInEntity: memberInEntity ?? this.memberInEntity,
      supervision: supervision ?? this.supervision,
      friend: friend ?? this.friend,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'member_in_entity': memberInEntity,
      'supervision': supervision,
      'friend': friend,
    };
  }

  factory Relationships.fromMap(Map<String, dynamic> map) {
    return Relationships(
      memberInEntity: map['member_in_entity'] ?? false,
      supervision: map['supervision'] ?? false,
      friend: map['friend'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Relationships.fromJson(String source) =>
      Relationships.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Relationships(memberInEntity: $memberInEntity, supervision: $supervision, friend: $friend)';

  @override
  bool operator ==(covariant Relationships other) {
    if (identical(this, other)) return true;

    return other.memberInEntity == memberInEntity &&
        other.supervision == supervision &&
        other.friend == friend;
  }

  @override
  int get hashCode =>
      memberInEntity.hashCode ^ supervision.hashCode ^ friend.hashCode;
}
