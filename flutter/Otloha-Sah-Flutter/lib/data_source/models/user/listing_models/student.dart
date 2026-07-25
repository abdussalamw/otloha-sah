import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

class Student {
  final int id;
  final String username;
  final String? image;
  final String email;
  final String rate;
  final String language;
  final String? narration;
  final Invitations invitations;
  final Relationships relationships;

  Student({
    required this.id,
    required this.username,
    required this.image,
    required this.email,
    required this.rate,
    required this.language,
    required this.narration,
    required this.invitations,
    required this.relationships,
  });

  Student copyWith({
    int? id,
    String? username,
    String? image,
    String? email,
    String? rate,
    String? language,
    String? narration,
    Invitations? invitations,
    Relationships? relationships,
  }) {
    return Student(
      id: id ?? this.id,
      username: username ?? this.username,
      image: image ?? this.image,
      email: email ?? this.email,
      rate: rate ?? this.rate,
      language: language ?? this.language,
      narration: narration ?? this.narration,
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
      'invitations': invitations.toMap(),
      'relationships': relationships.toMap(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      username: map['username'] as String,
      image: map['image'] as String?,
      email: map['email'] as String,
      rate: map['rate'] as String,
      language: map['language'] as String,
      narration: map['narration'] as String?,
      invitations: Invitations.fromMap(map['invitations'] ?? {}),
      relationships: Relationships.fromMap(map['relationships'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, image: $image, email: $email, rate: $rate, language: $language, narration: $narration)';
  }

  @override
  bool operator ==(covariant Student other) {
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
}
