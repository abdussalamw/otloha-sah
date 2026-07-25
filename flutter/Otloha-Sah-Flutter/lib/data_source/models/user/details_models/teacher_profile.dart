// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

class CertifiedNarration {
  final int id;
  final bool isCertified;
  CertifiedNarration({
    required this.id,
    required this.isCertified,
  });

  CertifiedNarration copyWith({
    int? id,
    bool? isCertified,
  }) {
    return CertifiedNarration(
      id: id ?? this.id,
      isCertified: isCertified ?? this.isCertified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isCertified': isCertified,
    };
  }

  factory CertifiedNarration.fromMap(Map<String, dynamic> map) {
    return CertifiedNarration(
      id: map['narration'] as int,
      isCertified: map['is_certified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CertifiedNarration.fromJson(String source) =>
      CertifiedNarration.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CertifiedNarration(id: $id, isCertified: $isCertified)';

  @override
  bool operator ==(covariant CertifiedNarration other) {
    if (identical(this, other)) return true;

    return other.id == id && other.isCertified == isCertified;
  }

  @override
  int get hashCode => id.hashCode ^ isCertified.hashCode;
}

class TeacherProfile {
  final int id;
  final int khatma;
  final int? recitation;
  final String username;
  final String image;
  final String rate;
  final String language;
  final List<CertifiedNarration> narrations;
  final String? bio;
  final String level;
  final String? favoriteTeacher;
  final Invitations invitations;
  final Relationships relationships;
  TeacherProfile({
    required this.id,
    required this.khatma,
    required this.username,
    required this.image,
    required this.rate,
    required this.language,
    required this.narrations,
    required this.recitation,
    this.bio,
    required this.level,
    this.favoriteTeacher,
    required this.invitations,
    required this.relationships,
  });

  TeacherProfile copyWith({
    int? id,
    int? khatma,
    String? username,
    String? image,
    String? rate,
    String? language,
    String? narration,
    int? recitation,
    List<CertifiedNarration>? narrations,
    String? bio,
    String? level,
    String? favoriteTeacher,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    return TeacherProfile(
      id: id ?? this.id,
      khatma: khatma ?? this.khatma,
      recitation: recitation ?? this.recitation,
      username: username ?? this.username,
      image: image ?? this.image,
      rate: rate ?? this.rate,
      language: language ?? this.language,
      narrations: narrations ?? this.narrations,
      bio: bio ?? this.bio,
      level: level ?? this.level,
      favoriteTeacher: favoriteTeacher ?? this.favoriteTeacher,
      invitations: invitations ?? this.invitations,
      relationships: relationships ?? this.relationships,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'khatma': khatma,
      'username': username,
      'image': image,
      'rate': rate,
      'language': language,
      'narrations': narrations.map((x) => x.toMap()).toList(),
      'bio': bio,
      'level': level,
      'favoriteTeacher': favoriteTeacher,
      'invitations': invitations.toMap(),
      'relationships': relationships.toMap(),
    };
  }

  factory TeacherProfile.fromMap(Map<String, dynamic> map) {
    return TeacherProfile(
      id: map['id'] as int,
      khatma: map['khatma'] as int,
      recitation: map['recitation'] as int?,
      username: map['username'] as String,
      image: map['image'] as String,
      rate: map['rate'] as String,
      language: map['language'] as String,
      narrations: List<CertifiedNarration>.from(
        (map['narration']).map<CertifiedNarration>(
          (x) => CertifiedNarration.fromMap(x as Map<String, dynamic>),
        ),
      ),
      bio: map['bio'] != null ? map['bio'] as String : null,
      level: map['level'] as String,
      favoriteTeacher: map['favorite_teacher'] != null
          ? map['favorite_teacher'] as String
          : null,
      invitations:
          Invitations.fromMap(map['invitations'] as Map<String, dynamic>),
      relationships:
          Relationships.fromMap(map['relationships'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherProfile.fromJson(String source) =>
      TeacherProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeacherProfile(id: $id, khatma: $khatma, username: $username, image: $image, rate: $rate, language: $language, narrations: $narrations, bio: $bio, level: $level, favoriteTeacher: $favoriteTeacher, invitations: $invitations, relationships: $relationships)';
  }

  @override
  bool operator ==(covariant TeacherProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.khatma == khatma &&
        other.username == username &&
        other.image == image &&
        other.rate == rate &&
        other.language == language &&
        listEquals(other.narrations, narrations) &&
        other.bio == bio &&
        other.level == level &&
        other.favoriteTeacher == favoriteTeacher &&
        other.invitations == invitations &&
        other.relationships == relationships;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        khatma.hashCode ^
        username.hashCode ^
        image.hashCode ^
        rate.hashCode ^
        language.hashCode ^
        narrations.hashCode ^
        bio.hashCode ^
        level.hashCode ^
        favoriteTeacher.hashCode ^
        invitations.hashCode ^
        relationships.hashCode;
  }
}
