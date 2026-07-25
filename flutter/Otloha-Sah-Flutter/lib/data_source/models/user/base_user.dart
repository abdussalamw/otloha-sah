import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';

class BaseUser {
  final int id;
  final String username;
  final String? image;
  final String email;
  final String rate;
  final String language;
  final String? narration;
  final bool? isTeacher;
  final Invitations? invitations;
  final Relationships? relationships;

  BaseUser({
    required this.id,
    required this.username,
    required this.image,
    required this.email,
    required this.rate,
    required this.language,
    required this.narration,
    required this.isTeacher,
    required this.invitations,
    required this.relationships,
  });

  BaseUser copyWith({
    int? id,
    String? username,
    String? image,
    String? email,
    String? rate,
    String? language,
    String? narration,
    bool? isTeacher,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    return BaseUser(
      id: id ?? this.id,
      username: username ?? this.username,
      image: image ?? this.image,
      email: email ?? this.email,
      rate: rate ?? this.rate,
      language: language ?? this.language,
      narration: narration ?? this.narration,
      isTeacher: isTeacher ?? this.isTeacher,
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
      'narration': narration,
      'is_a_teacher': isTeacher,
      'invitations': invitations?.toMap(),
      'relationships': relationships?.toMap(),
    };
  }

  factory BaseUser.fromMap(Map<String, dynamic> map) {
    return BaseUser(
      id: map['id'] as int,
      username: map['username'] as String,
      image: map['image'] as String?,
      email: map['email'] as String,
      rate: map['rate'] as String,
      language: map['language'] as String,
      narration: map['narration'] as String?,
      isTeacher: map['is_a_teacher'] as bool?,
      invitations: map['invitations'] == null
          ? null
          : Invitations.fromMap(map['invitations'] as Map<String, dynamic>),
      relationships: map['invitations'] == null
          ? null
          : Relationships.fromMap(map['relationships'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseUser.fromJson(String source) =>
      BaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, image: $image, email: $email, rate: $rate, language: $language, narration: $narration, isTeacher: $isTeacher)';
  }

  @override
  bool operator ==(covariant BaseUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.image == image &&
        other.email == email &&
        other.rate == rate &&
        other.language == language &&
        other.narration == narration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        image.hashCode ^
        email.hashCode ^
        rate.hashCode ^
        language.hashCode ^
        narration.hashCode;
  }

  Student toStudent() {
    return Student.fromMap(toMap());
  }

  Teacher toTeacher() {
    return Teacher.fromMap(toMap());
  }
}
