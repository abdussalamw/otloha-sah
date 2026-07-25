import 'dart:convert';

Addressee addresseeFromJson(String str) => Addressee.fromJson(json.decode(str));
String addresseeToJson(Addressee data) => json.encode(data.toJson());

class Addressee {
  Addressee({
    this.id,
    this.firstName,
    this.lastName,
    this.level,
    this.isATeacher,
    this.narrationId,
    this.image,
    this.teacherType,
    required this.username,
  });

  factory Addressee.fromJson(dynamic json) {
    return Addressee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      level: json['level'],
      isATeacher: json['is_a_teacher'],
      narrationId: json['narration_id'],
      image: json['image'],
      teacherType: json['teacher_type'],
      username: json['username'] ?? '',
    );
  }
  int? id;
  String? firstName;
  String? lastName;
  String? level;
  bool? isATeacher;
  String? narrationId;
  String? image;
  String? teacherType;
  String? username;
  Addressee copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? level,
    bool? isATeacher,
    String? narrationId,
    String? image,
    String? teacherType,
  }) =>
      Addressee(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        level: level ?? this.level,
        isATeacher: isATeacher ?? this.isATeacher,
        narrationId: narrationId ?? this.narrationId,
        image: image ?? this.image,
        teacherType: teacherType ?? this.teacherType,
        username: username ?? username,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['level'] = level;
    map['is_a_teacher'] = isATeacher;
    map['narration_id'] = narrationId;
    map['image'] = image;
    map['teacher_type'] = teacherType;
    return map;
  }
}
