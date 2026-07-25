// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sender {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String fullname;
  final String profileImage;
  Sender({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullname,
    required this.profileImage,
  });

  Sender copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? fullname,
    String? profileImage,
  }) {
    return Sender(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullname: fullname ?? this.fullname,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'fullname': fullname,
      'profileImage': profileImage,
    };
  }

  factory Sender.fromMap(Map<String, dynamic> map) {
    return Sender(
      id: map['id'] as int,
      username: map['username'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      fullname: map['fullname'] as String,
      profileImage: map['profile_image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sender.fromJson(String source) =>
      Sender.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sender(id: $id, username: $username, firstName: $firstName, lastName: $lastName, fullname: $fullname, profileImage: $profileImage)';
  }

  @override
  bool operator ==(covariant Sender other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullname == fullname &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        fullname.hashCode ^
        profileImage.hashCode;
  }
}
