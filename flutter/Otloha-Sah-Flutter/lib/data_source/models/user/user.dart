import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:otloha_sah_flutter/data_source/models/user/teacher_profile.dart';

import '../../local/database/database/database.dart';

@UseRowClass(User)
class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get email => text()();
  TextColumn get username => text()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get fullname => text().nullable()();
  TextColumn get emailVerifiedAt => text().nullable()();
  TextColumn get birthdate => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get level => text().nullable()();
  BoolColumn get isTeacher => boolean()();
  TextColumn get recitationMethod => text().nullable()();
  IntColumn get favoriteTeacher => integer().nullable()();

  TextColumn get profileImage => text().nullable()();
  RealColumn get rate => real().nullable()();
  BoolColumn get allowRemarkableRecitationsToPublic => boolean()();
  BoolColumn get allowCrossGenderView => boolean()();
  TextColumn get teacherProfile =>
      text().map(const TeacherProfileConverter()).nullable()();
  TextColumn get phoneVerifiedAt => text().nullable()();
  TextColumn get gender => text()();
  BoolColumn get isBlocked => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class User implements Insertable<User> {
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullname,
    required this.firstName,
    required this.lastName,
    required this.emailVerifiedAt,
    required this.birthdate,
    required this.language,
    required this.phone,
    required this.bio,
    required this.level,
    required this.isTeacher,
    required this.recitationMethod,
    required this.favoriteTeacher,
    required this.profileImage,
    required this.rate,
    required this.allowRemarkableRecitationsToPublic,
    required this.allowCrossGenderView,
    required this.teacherProfile,
    required this.phoneVerifiedAt,
    required this.gender,
    required this.isBlocked,
  });

  int id;
  String email;
  String username;
  String? fullname;
  String? firstName;
  String? lastName;
  String? emailVerifiedAt;
  String? birthdate;
  String? language;
  String? phone;
  String? bio;
  String? level;
  bool isTeacher;
  String? recitationMethod;
  int? favoriteTeacher;
  String? profileImage;
  double? rate;
  bool allowRemarkableRecitationsToPublic;
  bool allowCrossGenderView;
  TeacherProfile? teacherProfile;
  String gender;
  String? phoneVerifiedAt;
  bool isBlocked;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullname: json['fullname'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      emailVerifiedAt: json['email_verified_at'],
      birthdate: json['birthdate'],
      language: json['language'],
      phone: json['phone'],
      bio: json['bio'],
      level: json['level'],
      isTeacher: json['is_a_teacher'],
      recitationMethod: json['recitation_method'],
      favoriteTeacher: json['favorite_teacher'],
      profileImage: json['profile_image'],
      rate: json['rate'] is double
          ? json['rate']
          : double.parse(json['rate'] ?? '0.0'),
      allowRemarkableRecitationsToPublic:
          json['allow_remarkable_recitations_to_public'],
      allowCrossGenderView: json['allow_cross_gender_view'],
      teacherProfile: json['teacher_profile'] != null
          ? TeacherProfile.fromJson(json['teacher_profile'])
          : null,
      gender: json['gender'],
      phoneVerifiedAt: json['phone_verified_at'],
      isBlocked: json['is_blocked'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['username'] = username;
    map['fullname'] = fullname;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email_verified_at'] = emailVerifiedAt;
    map['birthdate'] = birthdate;
    map['language'] = language;
    map['phone'] = phone;
    map['bio'] = bio;
    map['level'] = level;
    map['is_a_teacher'] = isTeacher;
    map['recitation_method'] = recitationMethod;
    map['favorite_teacher'] = favoriteTeacher;
    map['profile_image'] = profileImage;
    map['rate'] = rate;
    map['allow_remarkable_recitations_to_public'] =
        allowRemarkableRecitationsToPublic;
    map['allow_cross_gender_view'] = allowCrossGenderView;
    if (teacherProfile != null) {
      map['teacher_profile'] = teacherProfile?.toJson();
    }
    map['gender'] = gender;
    map['phone_verified_at'] = phoneVerifiedAt;
    map['is_blocked'] = isBlocked;

    return map;
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      username: Value(username),
      fullname: Value(fullname),
      firstName: Value(firstName),
      lastName: Value(lastName),
      emailVerifiedAt: Value(emailVerifiedAt),
      birthdate: Value(birthdate),
      language: Value(language),
      phone: Value(phone),
      bio: Value(bio),
      level: Value(level),
      isTeacher: Value(isTeacher),
      recitationMethod: Value(recitationMethod),
      favoriteTeacher: Value(favoriteTeacher),
      profileImage: Value(profileImage),
      rate: Value(rate),
      allowRemarkableRecitationsToPublic:
          Value(allowRemarkableRecitationsToPublic),
      allowCrossGenderView: Value(allowCrossGenderView),
      teacherProfile: Value(teacherProfile),
      gender: Value(gender),
      phoneVerifiedAt: Value(phoneVerifiedAt),
      isBlocked: Value(isBlocked),
    ).toColumns(nullToAbsent);
  }
}

class UserConverter extends TypeConverter<User, String> {
  const UserConverter();

  @override
  User fromSql(String fromDb) {
    return User.fromJson(fromDb as Map<String, dynamic>);
  }

  @override
  String toSql(User value) {
    return jsonEncode(value.toJson());
  }
}
