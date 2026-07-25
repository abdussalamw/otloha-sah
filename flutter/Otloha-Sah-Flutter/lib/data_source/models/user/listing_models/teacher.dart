// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

class Teacher {
  final int id;
  final String username;
  final String? image;
  final String email;
  final String rate;
  final String language;
  final List<TeacherNarrartion>? narrations;
  final Invitations invitations;
  final Relationships relationships;
  Teacher({
    required this.id,
    required this.username,
    this.image,
    required this.email,
    required this.rate,
    required this.language,
    required this.narrations,
    required this.invitations,
    required this.relationships,
  });

  Teacher copyWith({
    int? id,
    String? username,
    String? image,
    String? email,
    String? rate,
    String? language,
    List<TeacherNarrartion>? narrations,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    print(invitations);
    return Teacher(
      id: id ?? this.id,
      username: username ?? this.username,
      image: image ?? this.image,
      email: email ?? this.email,
      rate: rate ?? this.rate,
      language: language ?? this.language,
      narrations: narrations ?? this.narrations,
      invitations: invitations ?? this.invitations,
      relationships: relationships ?? this.relationships,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'image': image,
      'email': email,
      'rate': rate,
      'language': language,
      'narrations': narrations?.map((x) => x.toMap()).toList(),
      'invitations': invitations.toMap(),
      'relationships': relationships.toMap(),
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> emptyMap = {};
    return Teacher(
      id: map['id'] as int,
      username: map['username'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      email: map['email'] as String,
      rate: map['rate'] as String,
      language: map['language'] as String,
      narrations: map['narrations'] == null
          ? null
          : List<TeacherNarrartion>.from(
              (map['narrations'] as List).map<TeacherNarrartion>(
                (x) => TeacherNarrartion.fromMap(x as Map<String, dynamic>),
              ),
            ),
      invitations: Invitations.fromMap(
          (map['invitations'] ?? emptyMap) as Map<String, dynamic>),
      relationships: Relationships.fromMap(
          (map['relationships'] ?? emptyMap) as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Teacher(id: $id, username: $username, image: $image, email: $email, rate: $rate, language: $language, narrations: $narrations, invitations: $invitations, relationships: $relationships)';
  }

  @override
  bool operator ==(covariant Teacher other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.image == image &&
        other.email == email &&
        other.rate == rate &&
        other.language == language &&
        listEquals(other.narrations, narrations) &&
        other.invitations == invitations &&
        other.relationships == relationships;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        image.hashCode ^
        email.hashCode ^
        rate.hashCode ^
        language.hashCode ^
        narrations.hashCode ^
        invitations.hashCode ^
        relationships.hashCode;
  }
}

class TeacherNarrartion {
  final int narration;
  final bool isCertified;

  TeacherNarrartion({
    required this.narration,
    required this.isCertified,
  });

  TeacherNarrartion copyWith({
    int? narration,
    bool? isCertified,
  }) {
    return TeacherNarrartion(
      narration: narration ?? this.narration,
      isCertified: isCertified ?? this.isCertified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'narration': narration,
      'is_certified': isCertified,
    };
  }

  factory TeacherNarrartion.fromMap(Map<String, dynamic> map) {
    return TeacherNarrartion(
      narration: map['narration'] as int,
      isCertified: map['is_certified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherNarrartion.fromJson(String source) =>
      TeacherNarrartion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TeacherNarrartion(narration: $narration, isCertified: $isCertified)';

  @override
  bool operator ==(covariant TeacherNarrartion other) {
    if (identical(this, other)) return true;

    return other.narration == narration && other.isCertified == isCertified;
  }

  @override
  int get hashCode => narration.hashCode ^ isCertified.hashCode;
}
