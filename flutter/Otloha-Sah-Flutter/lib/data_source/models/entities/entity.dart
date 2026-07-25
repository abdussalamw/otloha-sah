import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

class Entity {
  final int id;
  final String name;
  final String orgName;
  final String email;
  final String? logo;
  final String phone;
  final String? bio;
  final Invitations? invitations;
  final Relationships? relationships;
  Entity({
    required this.id,
    required this.name,
    required this.orgName,
    required this.email,
    this.logo,
    required this.bio,
    required this.invitations,
    required this.phone,
    required this.relationships,
  });

  Entity copyWith({
    int? id,
    String? name,
    String? orgName,
    String? email,
    String? logo,
    String? phone,
    String? bio,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      orgName: orgName ?? this.orgName,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      invitations: invitations ?? this.invitations,
      relationships: relationships ?? this.relationships,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'org_name': orgName,
      'email': email,
      'logo': logo,
      'phone': phone,
      'bio': bio,
      'invitations': invitations,
      'relationships': relationships,
    };
  }

  factory Entity.fromMap(Map<String, dynamic> map) {
    return Entity(
      id: map['id'] as int,
      name: map['name'] as String,
      orgName: map['org_name'] as String,
      email: map['email'] as String,
      logo: map['logo'] != null ? map['logo'] as String : null,
      phone: map['phone'],
      bio: map['bio'],
      invitations: Invitations.fromMap(map['invitations']),
      relationships: Relationships.fromMap(map['relationships']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Entity.fromJson(String source) =>
      Entity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Entity(id: $id, name: $name, orgName: $orgName, email: $email, logo: $logo)';
  }

  @override
  bool operator ==(covariant Entity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.orgName == orgName &&
        other.email == email &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        orgName.hashCode ^
        email.hashCode ^
        logo.hashCode;
  }
}
