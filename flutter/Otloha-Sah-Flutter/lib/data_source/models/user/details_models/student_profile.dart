import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

class StudentProfile {
  final int id;
  final int recitation;
  final int khatma;
  final String username;
  final String image;
  final String rate;
  final String language;
  final String narration;
  final String? bio;
  final String level;
  final String? favoriteTeacher;
  final Invitations invitations;
  final Relationships relationships;
  StudentProfile({
    required this.id,
    required this.recitation,
    required this.khatma,
    required this.username,
    required this.image,
    required this.rate,
    required this.language,
    required this.narration,
    this.bio,
    required this.level,
    this.favoriteTeacher,
    required this.invitations,
    required this.relationships,
  });

  StudentProfile copyWith({
    int? id,
    int? recitation,
    int? khatma,
    String? username,
    String? image,
    String? rate,
    String? language,
    String? narration,
    String? bio,
    String? level,
    String? favoriteTeacher,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      recitation: recitation ?? this.recitation,
      khatma: khatma ?? this.khatma,
      username: username ?? this.username,
      image: image ?? this.image,
      rate: rate ?? this.rate,
      language: language ?? this.language,
      narration: narration ?? this.narration,
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
      'recitation': recitation,
      'khatma': khatma,
      'username': username,
      'image': image,
      'rate': rate,
      'language': language,
      'narration': narration,
      'bio': bio,
      'level': level,
      'favoriteTeacher': favoriteTeacher,
      'invitations': invitations.toMap(),
      'relationships': relationships.toMap(),
    };
  }

  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    return StudentProfile(
      id: map['id'] as int,
      recitation: map['recitation'] as int,
      khatma: map['khatma'] as int,
      username: map['username'] as String,
      image: map['image'] as String,
      rate: map['rate'] as String,
      language: map['language'] as String,
      narration: map['narration'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      level: map['level'] as String,
      favoriteTeacher: map['favorite_teacher'] as String?,
      invitations:
          Invitations.fromMap(map['invitations'] as Map<String, dynamic>),
      relationships:
          Relationships.fromMap(map['relationships'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentProfile.fromJson(String source) =>
      StudentProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentProfile(id: $id, recitation: $recitation, khatma: $khatma, username: $username, image: $image, rate: $rate, language: $language, narration: $narration, bio: $bio, level: $level, favoriteTeacher: $favoriteTeacher, invitations: $invitations, relationships: $relationships)';
  }

  @override
  bool operator ==(covariant StudentProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.recitation == recitation &&
        other.khatma == khatma &&
        other.username == username &&
        other.image == image &&
        other.rate == rate &&
        other.language == language &&
        other.narration == narration &&
        other.bio == bio &&
        other.level == level &&
        other.favoriteTeacher == favoriteTeacher &&
        other.invitations == invitations &&
        other.relationships == relationships;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        recitation.hashCode ^
        khatma.hashCode ^
        username.hashCode ^
        image.hashCode ^
        rate.hashCode ^
        language.hashCode ^
        narration.hashCode ^
        bio.hashCode ^
        level.hashCode ^
        favoriteTeacher.hashCode ^
        invitations.hashCode ^
        relationships.hashCode;
  }
}
