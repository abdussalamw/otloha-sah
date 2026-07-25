import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:otloha_sah_flutter/data_source/models/user/certification.dart';

class TeacherProfile {
  TeacherProfile({
    this.fullName,
    this.teacherType,
    this.status,
    this.isCertified,
    this.educationDegree,
    this.isProfileComplete,
    this.canReplyOnEveryVerseInRecitation,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  TeacherProfile.fromJson(dynamic json) {
    fullName = json['full_name'];
    teacherType = json['teacher_type'];
    status = json['status'];
    isCertified = json['is_certified'];
    educationDegree = json['education_degree'];
    isProfileComplete = json['is_profile_complete'];
    canReplyOnEveryVerseInRecitation =
        json['can_reply_on_every_verse_in_recitation'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    certifications = json['certifications']!
        .map<Certification>((v) =>
            v is String ? Certification.fromJson(v) : Certification.fromMap(v))
        .toList();
  }
  String? fullName;
  String? teacherType;
  String? status;
  bool? isCertified;
  String? educationDegree;
  bool? isProfileComplete;
  bool? canReplyOnEveryVerseInRecitation;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<Certification>? certifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = fullName;
    map['teacher_type'] = teacherType;
    map['status'] = status;
    map['is_certified'] = isCertified;
    map['education_degree'] = educationDegree;
    map['is_profile_complete'] = isProfileComplete;
    map['can_reply_on_every_verse_in_recitation'] =
        canReplyOnEveryVerseInRecitation;
    map['is_active'] = isActive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (certifications != null) {
      map['certifications'] = certifications!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TeacherProfileConverter extends TypeConverter<TeacherProfile, String> {
  const TeacherProfileConverter();

  @override
  TeacherProfile fromSql(String fromDb) {
    return TeacherProfile.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(TeacherProfile value) {
    return jsonEncode(value.toJson());
  }
}
