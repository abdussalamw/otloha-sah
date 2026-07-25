// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullnameMeta =
      const VerificationMeta('fullname');
  @override
  late final GeneratedColumn<String> fullname = GeneratedColumn<String>(
      'fullname', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailVerifiedAtMeta =
      const VerificationMeta('emailVerifiedAt');
  @override
  late final GeneratedColumn<String> emailVerifiedAt = GeneratedColumn<String>(
      'email_verified_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthdateMeta =
      const VerificationMeta('birthdate');
  @override
  late final GeneratedColumn<String> birthdate = GeneratedColumn<String>(
      'birthdate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isTeacherMeta =
      const VerificationMeta('isTeacher');
  @override
  late final GeneratedColumn<bool> isTeacher = GeneratedColumn<bool>(
      'is_teacher', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_teacher" IN (0, 1))'));
  static const VerificationMeta _recitationMethodMeta =
      const VerificationMeta('recitationMethod');
  @override
  late final GeneratedColumn<String> recitationMethod = GeneratedColumn<String>(
      'recitation_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _favoriteTeacherMeta =
      const VerificationMeta('favoriteTeacher');
  @override
  late final GeneratedColumn<int> favoriteTeacher = GeneratedColumn<int>(
      'favorite_teacher', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _allowRemarkableRecitationsToPublicMeta =
      const VerificationMeta('allowRemarkableRecitationsToPublic');
  @override
  late final GeneratedColumn<bool> allowRemarkableRecitationsToPublic =
      GeneratedColumn<bool>(
          'allow_remarkable_recitations_to_public', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("allow_remarkable_recitations_to_public" IN (0, 1))'));
  static const VerificationMeta _allowCrossGenderViewMeta =
      const VerificationMeta('allowCrossGenderView');
  @override
  late final GeneratedColumn<bool> allowCrossGenderView = GeneratedColumn<bool>(
      'allow_cross_gender_view', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_cross_gender_view" IN (0, 1))'));
  static const VerificationMeta _teacherProfileMeta =
      const VerificationMeta('teacherProfile');
  @override
  late final GeneratedColumnWithTypeConverter<TeacherProfile?, String>
      teacherProfile = GeneratedColumn<String>(
              'teacher_profile', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<TeacherProfile?>(
              $UsersTable.$converterteacherProfilen);
  static const VerificationMeta _phoneVerifiedAtMeta =
      const VerificationMeta('phoneVerifiedAt');
  @override
  late final GeneratedColumn<String> phoneVerifiedAt = GeneratedColumn<String>(
      'phone_verified_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBlockedMeta =
      const VerificationMeta('isBlocked');
  @override
  late final GeneratedColumn<bool> isBlocked = GeneratedColumn<bool>(
      'is_blocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_blocked" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        username,
        firstName,
        lastName,
        fullname,
        emailVerifiedAt,
        birthdate,
        language,
        phone,
        bio,
        level,
        isTeacher,
        recitationMethod,
        favoriteTeacher,
        profileImage,
        rate,
        allowRemarkableRecitationsToPublic,
        allowCrossGenderView,
        teacherProfile,
        phoneVerifiedAt,
        gender,
        isBlocked
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('fullname')) {
      context.handle(_fullnameMeta,
          fullname.isAcceptableOrUnknown(data['fullname']!, _fullnameMeta));
    }
    if (data.containsKey('email_verified_at')) {
      context.handle(
          _emailVerifiedAtMeta,
          emailVerifiedAt.isAcceptableOrUnknown(
              data['email_verified_at']!, _emailVerifiedAtMeta));
    }
    if (data.containsKey('birthdate')) {
      context.handle(_birthdateMeta,
          birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('is_teacher')) {
      context.handle(_isTeacherMeta,
          isTeacher.isAcceptableOrUnknown(data['is_teacher']!, _isTeacherMeta));
    } else if (isInserting) {
      context.missing(_isTeacherMeta);
    }
    if (data.containsKey('recitation_method')) {
      context.handle(
          _recitationMethodMeta,
          recitationMethod.isAcceptableOrUnknown(
              data['recitation_method']!, _recitationMethodMeta));
    }
    if (data.containsKey('favorite_teacher')) {
      context.handle(
          _favoriteTeacherMeta,
          favoriteTeacher.isAcceptableOrUnknown(
              data['favorite_teacher']!, _favoriteTeacherMeta));
    }
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    }
    if (data.containsKey('allow_remarkable_recitations_to_public')) {
      context.handle(
          _allowRemarkableRecitationsToPublicMeta,
          allowRemarkableRecitationsToPublic.isAcceptableOrUnknown(
              data['allow_remarkable_recitations_to_public']!,
              _allowRemarkableRecitationsToPublicMeta));
    } else if (isInserting) {
      context.missing(_allowRemarkableRecitationsToPublicMeta);
    }
    if (data.containsKey('allow_cross_gender_view')) {
      context.handle(
          _allowCrossGenderViewMeta,
          allowCrossGenderView.isAcceptableOrUnknown(
              data['allow_cross_gender_view']!, _allowCrossGenderViewMeta));
    } else if (isInserting) {
      context.missing(_allowCrossGenderViewMeta);
    }
    context.handle(_teacherProfileMeta, const VerificationResult.success());
    if (data.containsKey('phone_verified_at')) {
      context.handle(
          _phoneVerifiedAtMeta,
          phoneVerifiedAt.isAcceptableOrUnknown(
              data['phone_verified_at']!, _phoneVerifiedAtMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('is_blocked')) {
      context.handle(_isBlockedMeta,
          isBlocked.isAcceptableOrUnknown(data['is_blocked']!, _isBlockedMeta));
    } else if (isInserting) {
      context.missing(_isBlockedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      fullname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fullname']),
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      emailVerifiedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}email_verified_at']),
      birthdate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birthdate']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      isTeacher: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_teacher'])!,
      recitationMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recitation_method']),
      favoriteTeacher: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}favorite_teacher']),
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image']),
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate']),
      allowRemarkableRecitationsToPublic: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}allow_remarkable_recitations_to_public'])!,
      allowCrossGenderView: attachedDatabase.typeMapping.read(DriftSqlType.bool,
          data['${effectivePrefix}allow_cross_gender_view'])!,
      teacherProfile: $UsersTable.$converterteacherProfilen.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}teacher_profile'])),
      phoneVerifiedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}phone_verified_at']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      isBlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_blocked'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static TypeConverter<TeacherProfile, String> $converterteacherProfile =
      const TeacherProfileConverter();
  static TypeConverter<TeacherProfile?, String?> $converterteacherProfilen =
      NullAwareTypeConverter.wrap($converterteacherProfile);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> username;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> fullname;
  final Value<String?> emailVerifiedAt;
  final Value<String?> birthdate;
  final Value<String?> language;
  final Value<String?> phone;
  final Value<String?> bio;
  final Value<String?> level;
  final Value<bool> isTeacher;
  final Value<String?> recitationMethod;
  final Value<int?> favoriteTeacher;
  final Value<String?> profileImage;
  final Value<double?> rate;
  final Value<bool> allowRemarkableRecitationsToPublic;
  final Value<bool> allowCrossGenderView;
  final Value<TeacherProfile?> teacherProfile;
  final Value<String?> phoneVerifiedAt;
  final Value<String> gender;
  final Value<bool> isBlocked;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.fullname = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.language = const Value.absent(),
    this.phone = const Value.absent(),
    this.bio = const Value.absent(),
    this.level = const Value.absent(),
    this.isTeacher = const Value.absent(),
    this.recitationMethod = const Value.absent(),
    this.favoriteTeacher = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.rate = const Value.absent(),
    this.allowRemarkableRecitationsToPublic = const Value.absent(),
    this.allowCrossGenderView = const Value.absent(),
    this.teacherProfile = const Value.absent(),
    this.phoneVerifiedAt = const Value.absent(),
    this.gender = const Value.absent(),
    this.isBlocked = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String username,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.fullname = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.language = const Value.absent(),
    this.phone = const Value.absent(),
    this.bio = const Value.absent(),
    this.level = const Value.absent(),
    required bool isTeacher,
    this.recitationMethod = const Value.absent(),
    this.favoriteTeacher = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.rate = const Value.absent(),
    required bool allowRemarkableRecitationsToPublic,
    required bool allowCrossGenderView,
    this.teacherProfile = const Value.absent(),
    this.phoneVerifiedAt = const Value.absent(),
    required String gender,
    required bool isBlocked,
  })  : email = Value(email),
        username = Value(username),
        isTeacher = Value(isTeacher),
        allowRemarkableRecitationsToPublic =
            Value(allowRemarkableRecitationsToPublic),
        allowCrossGenderView = Value(allowCrossGenderView),
        gender = Value(gender),
        isBlocked = Value(isBlocked);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? username,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? fullname,
    Expression<String>? emailVerifiedAt,
    Expression<String>? birthdate,
    Expression<String>? language,
    Expression<String>? phone,
    Expression<String>? bio,
    Expression<String>? level,
    Expression<bool>? isTeacher,
    Expression<String>? recitationMethod,
    Expression<int>? favoriteTeacher,
    Expression<String>? profileImage,
    Expression<double>? rate,
    Expression<bool>? allowRemarkableRecitationsToPublic,
    Expression<bool>? allowCrossGenderView,
    Expression<String>? teacherProfile,
    Expression<String>? phoneVerifiedAt,
    Expression<String>? gender,
    Expression<bool>? isBlocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (fullname != null) 'fullname': fullname,
      if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
      if (birthdate != null) 'birthdate': birthdate,
      if (language != null) 'language': language,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (level != null) 'level': level,
      if (isTeacher != null) 'is_teacher': isTeacher,
      if (recitationMethod != null) 'recitation_method': recitationMethod,
      if (favoriteTeacher != null) 'favorite_teacher': favoriteTeacher,
      if (profileImage != null) 'profile_image': profileImage,
      if (rate != null) 'rate': rate,
      if (allowRemarkableRecitationsToPublic != null)
        'allow_remarkable_recitations_to_public':
            allowRemarkableRecitationsToPublic,
      if (allowCrossGenderView != null)
        'allow_cross_gender_view': allowCrossGenderView,
      if (teacherProfile != null) 'teacher_profile': teacherProfile,
      if (phoneVerifiedAt != null) 'phone_verified_at': phoneVerifiedAt,
      if (gender != null) 'gender': gender,
      if (isBlocked != null) 'is_blocked': isBlocked,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String>? username,
      Value<String?>? firstName,
      Value<String?>? lastName,
      Value<String?>? fullname,
      Value<String?>? emailVerifiedAt,
      Value<String?>? birthdate,
      Value<String?>? language,
      Value<String?>? phone,
      Value<String?>? bio,
      Value<String?>? level,
      Value<bool>? isTeacher,
      Value<String?>? recitationMethod,
      Value<int?>? favoriteTeacher,
      Value<String?>? profileImage,
      Value<double?>? rate,
      Value<bool>? allowRemarkableRecitationsToPublic,
      Value<bool>? allowCrossGenderView,
      Value<TeacherProfile?>? teacherProfile,
      Value<String?>? phoneVerifiedAt,
      Value<String>? gender,
      Value<bool>? isBlocked}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullname: fullname ?? this.fullname,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      birthdate: birthdate ?? this.birthdate,
      language: language ?? this.language,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      level: level ?? this.level,
      isTeacher: isTeacher ?? this.isTeacher,
      recitationMethod: recitationMethod ?? this.recitationMethod,
      favoriteTeacher: favoriteTeacher ?? this.favoriteTeacher,
      profileImage: profileImage ?? this.profileImage,
      rate: rate ?? this.rate,
      allowRemarkableRecitationsToPublic: allowRemarkableRecitationsToPublic ??
          this.allowRemarkableRecitationsToPublic,
      allowCrossGenderView: allowCrossGenderView ?? this.allowCrossGenderView,
      teacherProfile: teacherProfile ?? this.teacherProfile,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      gender: gender ?? this.gender,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (fullname.present) {
      map['fullname'] = Variable<String>(fullname.value);
    }
    if (emailVerifiedAt.present) {
      map['email_verified_at'] = Variable<String>(emailVerifiedAt.value);
    }
    if (birthdate.present) {
      map['birthdate'] = Variable<String>(birthdate.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (isTeacher.present) {
      map['is_teacher'] = Variable<bool>(isTeacher.value);
    }
    if (recitationMethod.present) {
      map['recitation_method'] = Variable<String>(recitationMethod.value);
    }
    if (favoriteTeacher.present) {
      map['favorite_teacher'] = Variable<int>(favoriteTeacher.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (allowRemarkableRecitationsToPublic.present) {
      map['allow_remarkable_recitations_to_public'] =
          Variable<bool>(allowRemarkableRecitationsToPublic.value);
    }
    if (allowCrossGenderView.present) {
      map['allow_cross_gender_view'] =
          Variable<bool>(allowCrossGenderView.value);
    }
    if (teacherProfile.present) {
      map['teacher_profile'] = Variable<String>(
          $UsersTable.$converterteacherProfilen.toSql(teacherProfile.value));
    }
    if (phoneVerifiedAt.present) {
      map['phone_verified_at'] = Variable<String>(phoneVerifiedAt.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (isBlocked.present) {
      map['is_blocked'] = Variable<bool>(isBlocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('fullname: $fullname, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('birthdate: $birthdate, ')
          ..write('language: $language, ')
          ..write('phone: $phone, ')
          ..write('bio: $bio, ')
          ..write('level: $level, ')
          ..write('isTeacher: $isTeacher, ')
          ..write('recitationMethod: $recitationMethod, ')
          ..write('favoriteTeacher: $favoriteTeacher, ')
          ..write('profileImage: $profileImage, ')
          ..write('rate: $rate, ')
          ..write(
              'allowRemarkableRecitationsToPublic: $allowRemarkableRecitationsToPublic, ')
          ..write('allowCrossGenderView: $allowCrossGenderView, ')
          ..write('teacherProfile: $teacherProfile, ')
          ..write('phoneVerifiedAt: $phoneVerifiedAt, ')
          ..write('gender: $gender, ')
          ..write('isBlocked: $isBlocked')
          ..write(')'))
        .toString();
  }
}

class $RecitationsTable extends Recitations
    with TableInfo<$RecitationsTable, Recitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _narrationIdMeta =
      const VerificationMeta('narrationId');
  @override
  late final GeneratedColumn<String> narrationId = GeneratedColumn<String>(
      'narration_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verseIdsMeta =
      const VerificationMeta('verseIds');
  @override
  late final GeneratedColumn<String> verseIds = GeneratedColumn<String>(
      'verse_ids', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordMeta = const VerificationMeta('record');
  @override
  late final GeneratedColumnWithTypeConverter<Record?, String> record =
      GeneratedColumn<String>('record', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Record?>($RecitationsTable.$converterrecordn);
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumnWithTypeConverter<User?, String> owner =
      GeneratedColumn<String>('owner', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<User?>($RecitationsTable.$converterownern);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _teacherMeta =
      const VerificationMeta('teacher');
  @override
  late final GeneratedColumnWithTypeConverter<User?, String> teacher =
      GeneratedColumn<String>('teacher', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<User?>($RecitationsTable.$converterteachern);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isChildMeta =
      const VerificationMeta('isChild');
  @override
  late final GeneratedColumn<bool> isChild = GeneratedColumn<bool>(
      'is_child', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_child" IN (0, 1))'));
  static const VerificationMeta _isTeacherRecitationMeta =
      const VerificationMeta('isTeacherRecitation');
  @override
  late final GeneratedColumn<bool> isTeacherRecitation = GeneratedColumn<bool>(
      'is_teacher_recitation', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_teacher_recitation" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<String> finishedAt = GeneratedColumn<String>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _teacherRateMeta =
      const VerificationMeta('teacherRate');
  @override
  late final GeneratedColumn<String> teacherRate = GeneratedColumn<String>(
      'teacher_rate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ownerRateMeta =
      const VerificationMeta('ownerRate');
  @override
  late final GeneratedColumn<double> ownerRate = GeneratedColumn<double>(
      'owner_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<String> archivedAt = GeneratedColumn<String>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evaluatedAtMeta =
      const VerificationMeta('evaluatedAt');
  @override
  late final GeneratedColumn<String> evaluatedAt = GeneratedColumn<String>(
      'evaluated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<String> closedAt = GeneratedColumn<String>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRemarkableMeta =
      const VerificationMeta('isRemarkable');
  @override
  late final GeneratedColumn<bool> isRemarkable = GeneratedColumn<bool>(
      'is_remarkable', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_remarkable" IN (0, 1))'));
  static const VerificationMeta _conversationStartedMeta =
      const VerificationMeta('conversationStarted');
  @override
  late final GeneratedColumn<bool> conversationStarted = GeneratedColumn<bool>(
      'conversation_started', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("conversation_started" IN (0, 1))'));
  static const VerificationMeta _beingEvaluatedMeta =
      const VerificationMeta('beingEvaluated');
  @override
  late final GeneratedColumn<bool> beingEvaluated = GeneratedColumn<bool>(
      'being_evaluated', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("being_evaluated" IN (0, 1))'));
  static const VerificationMeta _isClosedMeta =
      const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
      'is_closed', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'));
  static const VerificationMeta _showInGeneralMeta =
      const VerificationMeta('showInGeneral');
  @override
  late final GeneratedColumn<bool> showInGeneral = GeneratedColumn<bool>(
      'show_in_general', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_in_general" IN (0, 1))'));
  static const VerificationMeta _showInRemarkableMeta =
      const VerificationMeta('showInRemarkable');
  @override
  late final GeneratedColumn<bool> showInRemarkable = GeneratedColumn<bool>(
      'show_in_remarkable', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_in_remarkable" IN (0, 1))'));
  static const VerificationMeta _canCreateMessageMeta =
      const VerificationMeta('canCreateMessage');
  @override
  late final GeneratedColumn<bool> canCreateMessage = GeneratedColumn<bool>(
      'can_create_message', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_create_message" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        narrationId,
        verseIds,
        chapterId,
        record,
        owner,
        ownerId,
        teacher,
        gender,
        isChild,
        isTeacherRecitation,
        updatedAt,
        createdAt,
        finishedAt,
        teacherRate,
        ownerRate,
        result,
        archivedAt,
        evaluatedAt,
        closedAt,
        isRemarkable,
        conversationStarted,
        beingEvaluated,
        isClosed,
        showInGeneral,
        showInRemarkable,
        canCreateMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recitations';
  @override
  VerificationContext validateIntegrity(Insertable<Recitation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('narration_id')) {
      context.handle(
          _narrationIdMeta,
          narrationId.isAcceptableOrUnknown(
              data['narration_id']!, _narrationIdMeta));
    }
    if (data.containsKey('verse_ids')) {
      context.handle(_verseIdsMeta,
          verseIds.isAcceptableOrUnknown(data['verse_ids']!, _verseIdsMeta));
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    }
    context.handle(_recordMeta, const VerificationResult.success());
    context.handle(_ownerMeta, const VerificationResult.success());
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    }
    context.handle(_teacherMeta, const VerificationResult.success());
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('is_child')) {
      context.handle(_isChildMeta,
          isChild.isAcceptableOrUnknown(data['is_child']!, _isChildMeta));
    }
    if (data.containsKey('is_teacher_recitation')) {
      context.handle(
          _isTeacherRecitationMeta,
          isTeacherRecitation.isAcceptableOrUnknown(
              data['is_teacher_recitation']!, _isTeacherRecitationMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('teacher_rate')) {
      context.handle(
          _teacherRateMeta,
          teacherRate.isAcceptableOrUnknown(
              data['teacher_rate']!, _teacherRateMeta));
    }
    if (data.containsKey('owner_rate')) {
      context.handle(_ownerRateMeta,
          ownerRate.isAcceptableOrUnknown(data['owner_rate']!, _ownerRateMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('evaluated_at')) {
      context.handle(
          _evaluatedAtMeta,
          evaluatedAt.isAcceptableOrUnknown(
              data['evaluated_at']!, _evaluatedAtMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('is_remarkable')) {
      context.handle(
          _isRemarkableMeta,
          isRemarkable.isAcceptableOrUnknown(
              data['is_remarkable']!, _isRemarkableMeta));
    }
    if (data.containsKey('conversation_started')) {
      context.handle(
          _conversationStartedMeta,
          conversationStarted.isAcceptableOrUnknown(
              data['conversation_started']!, _conversationStartedMeta));
    }
    if (data.containsKey('being_evaluated')) {
      context.handle(
          _beingEvaluatedMeta,
          beingEvaluated.isAcceptableOrUnknown(
              data['being_evaluated']!, _beingEvaluatedMeta));
    }
    if (data.containsKey('is_closed')) {
      context.handle(_isClosedMeta,
          isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta));
    }
    if (data.containsKey('show_in_general')) {
      context.handle(
          _showInGeneralMeta,
          showInGeneral.isAcceptableOrUnknown(
              data['show_in_general']!, _showInGeneralMeta));
    }
    if (data.containsKey('show_in_remarkable')) {
      context.handle(
          _showInRemarkableMeta,
          showInRemarkable.isAcceptableOrUnknown(
              data['show_in_remarkable']!, _showInRemarkableMeta));
    }
    if (data.containsKey('can_create_message')) {
      context.handle(
          _canCreateMessageMeta,
          canCreateMessage.isAcceptableOrUnknown(
              data['can_create_message']!, _canCreateMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recitation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      narrationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}narration_id']),
      verseIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_ids']),
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id']),
      record: $RecitationsTable.$converterrecordn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record'])),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      isChild: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_child']),
      isTeacherRecitation: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_teacher_recitation']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      teacherRate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_rate']),
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result']),
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finished_at']),
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}archived_at']),
      isRemarkable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_remarkable']),
      conversationStarted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}conversation_started']),
      beingEvaluated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}being_evaluated']),
      evaluatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evaluated_at']),
      isClosed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closed']),
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}closed_at']),
      showInGeneral: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_in_general']),
      showInRemarkable: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_in_remarkable']),
      owner: $RecitationsTable.$converterownern.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner'])),
      teacher: $RecitationsTable.$converterteachern.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher'])),
      ownerRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}owner_rate']),
      canCreateMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}can_create_message']),
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id']),
    );
  }

  @override
  $RecitationsTable createAlias(String alias) {
    return $RecitationsTable(attachedDatabase, alias);
  }

  static TypeConverter<Record, String> $converterrecord =
      const RecordConverter();
  static TypeConverter<Record?, String?> $converterrecordn =
      NullAwareTypeConverter.wrap($converterrecord);
  static TypeConverter<User, String> $converterowner = const UserConverter();
  static TypeConverter<User?, String?> $converterownern =
      NullAwareTypeConverter.wrap($converterowner);
  static TypeConverter<User, String> $converterteacher = const UserConverter();
  static TypeConverter<User?, String?> $converterteachern =
      NullAwareTypeConverter.wrap($converterteacher);
}

class RecitationsCompanion extends UpdateCompanion<Recitation> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> narrationId;
  final Value<String?> verseIds;
  final Value<String?> chapterId;
  final Value<Record?> record;
  final Value<User?> owner;
  final Value<int?> ownerId;
  final Value<User?> teacher;
  final Value<String?> gender;
  final Value<bool?> isChild;
  final Value<bool?> isTeacherRecitation;
  final Value<String?> updatedAt;
  final Value<String?> createdAt;
  final Value<String?> finishedAt;
  final Value<String?> teacherRate;
  final Value<double?> ownerRate;
  final Value<String?> result;
  final Value<String?> archivedAt;
  final Value<String?> evaluatedAt;
  final Value<String?> closedAt;
  final Value<bool?> isRemarkable;
  final Value<bool?> conversationStarted;
  final Value<bool?> beingEvaluated;
  final Value<bool?> isClosed;
  final Value<bool?> showInGeneral;
  final Value<bool?> showInRemarkable;
  final Value<bool?> canCreateMessage;
  const RecitationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.narrationId = const Value.absent(),
    this.verseIds = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.record = const Value.absent(),
    this.owner = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.teacher = const Value.absent(),
    this.gender = const Value.absent(),
    this.isChild = const Value.absent(),
    this.isTeacherRecitation = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.teacherRate = const Value.absent(),
    this.ownerRate = const Value.absent(),
    this.result = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.evaluatedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.isRemarkable = const Value.absent(),
    this.conversationStarted = const Value.absent(),
    this.beingEvaluated = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.showInGeneral = const Value.absent(),
    this.showInRemarkable = const Value.absent(),
    this.canCreateMessage = const Value.absent(),
  });
  RecitationsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.narrationId = const Value.absent(),
    this.verseIds = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.record = const Value.absent(),
    this.owner = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.teacher = const Value.absent(),
    this.gender = const Value.absent(),
    this.isChild = const Value.absent(),
    this.isTeacherRecitation = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.teacherRate = const Value.absent(),
    this.ownerRate = const Value.absent(),
    this.result = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.evaluatedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.isRemarkable = const Value.absent(),
    this.conversationStarted = const Value.absent(),
    this.beingEvaluated = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.showInGeneral = const Value.absent(),
    this.showInRemarkable = const Value.absent(),
    this.canCreateMessage = const Value.absent(),
  });
  static Insertable<Recitation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? narrationId,
    Expression<String>? verseIds,
    Expression<String>? chapterId,
    Expression<String>? record,
    Expression<String>? owner,
    Expression<int>? ownerId,
    Expression<String>? teacher,
    Expression<String>? gender,
    Expression<bool>? isChild,
    Expression<bool>? isTeacherRecitation,
    Expression<String>? updatedAt,
    Expression<String>? createdAt,
    Expression<String>? finishedAt,
    Expression<String>? teacherRate,
    Expression<double>? ownerRate,
    Expression<String>? result,
    Expression<String>? archivedAt,
    Expression<String>? evaluatedAt,
    Expression<String>? closedAt,
    Expression<bool>? isRemarkable,
    Expression<bool>? conversationStarted,
    Expression<bool>? beingEvaluated,
    Expression<bool>? isClosed,
    Expression<bool>? showInGeneral,
    Expression<bool>? showInRemarkable,
    Expression<bool>? canCreateMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (narrationId != null) 'narration_id': narrationId,
      if (verseIds != null) 'verse_ids': verseIds,
      if (chapterId != null) 'chapter_id': chapterId,
      if (record != null) 'record': record,
      if (owner != null) 'owner': owner,
      if (ownerId != null) 'owner_id': ownerId,
      if (teacher != null) 'teacher': teacher,
      if (gender != null) 'gender': gender,
      if (isChild != null) 'is_child': isChild,
      if (isTeacherRecitation != null)
        'is_teacher_recitation': isTeacherRecitation,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (teacherRate != null) 'teacher_rate': teacherRate,
      if (ownerRate != null) 'owner_rate': ownerRate,
      if (result != null) 'result': result,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (evaluatedAt != null) 'evaluated_at': evaluatedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (isRemarkable != null) 'is_remarkable': isRemarkable,
      if (conversationStarted != null)
        'conversation_started': conversationStarted,
      if (beingEvaluated != null) 'being_evaluated': beingEvaluated,
      if (isClosed != null) 'is_closed': isClosed,
      if (showInGeneral != null) 'show_in_general': showInGeneral,
      if (showInRemarkable != null) 'show_in_remarkable': showInRemarkable,
      if (canCreateMessage != null) 'can_create_message': canCreateMessage,
    });
  }

  RecitationsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? narrationId,
      Value<String?>? verseIds,
      Value<String?>? chapterId,
      Value<Record?>? record,
      Value<User?>? owner,
      Value<int?>? ownerId,
      Value<User?>? teacher,
      Value<String?>? gender,
      Value<bool?>? isChild,
      Value<bool?>? isTeacherRecitation,
      Value<String?>? updatedAt,
      Value<String?>? createdAt,
      Value<String?>? finishedAt,
      Value<String?>? teacherRate,
      Value<double?>? ownerRate,
      Value<String?>? result,
      Value<String?>? archivedAt,
      Value<String?>? evaluatedAt,
      Value<String?>? closedAt,
      Value<bool?>? isRemarkable,
      Value<bool?>? conversationStarted,
      Value<bool?>? beingEvaluated,
      Value<bool?>? isClosed,
      Value<bool?>? showInGeneral,
      Value<bool?>? showInRemarkable,
      Value<bool?>? canCreateMessage}) {
    return RecitationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      narrationId: narrationId ?? this.narrationId,
      verseIds: verseIds ?? this.verseIds,
      chapterId: chapterId ?? this.chapterId,
      record: record ?? this.record,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      teacher: teacher ?? this.teacher,
      gender: gender ?? this.gender,
      isChild: isChild ?? this.isChild,
      isTeacherRecitation: isTeacherRecitation ?? this.isTeacherRecitation,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt ?? this.finishedAt,
      teacherRate: teacherRate ?? this.teacherRate,
      ownerRate: ownerRate ?? this.ownerRate,
      result: result ?? this.result,
      archivedAt: archivedAt ?? this.archivedAt,
      evaluatedAt: evaluatedAt ?? this.evaluatedAt,
      closedAt: closedAt ?? this.closedAt,
      isRemarkable: isRemarkable ?? this.isRemarkable,
      conversationStarted: conversationStarted ?? this.conversationStarted,
      beingEvaluated: beingEvaluated ?? this.beingEvaluated,
      isClosed: isClosed ?? this.isClosed,
      showInGeneral: showInGeneral ?? this.showInGeneral,
      showInRemarkable: showInRemarkable ?? this.showInRemarkable,
      canCreateMessage: canCreateMessage ?? this.canCreateMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (narrationId.present) {
      map['narration_id'] = Variable<String>(narrationId.value);
    }
    if (verseIds.present) {
      map['verse_ids'] = Variable<String>(verseIds.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (record.present) {
      map['record'] = Variable<String>(
          $RecitationsTable.$converterrecordn.toSql(record.value));
    }
    if (owner.present) {
      map['owner'] = Variable<String>(
          $RecitationsTable.$converterownern.toSql(owner.value));
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (teacher.present) {
      map['teacher'] = Variable<String>(
          $RecitationsTable.$converterteachern.toSql(teacher.value));
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (isChild.present) {
      map['is_child'] = Variable<bool>(isChild.value);
    }
    if (isTeacherRecitation.present) {
      map['is_teacher_recitation'] = Variable<bool>(isTeacherRecitation.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<String>(finishedAt.value);
    }
    if (teacherRate.present) {
      map['teacher_rate'] = Variable<String>(teacherRate.value);
    }
    if (ownerRate.present) {
      map['owner_rate'] = Variable<double>(ownerRate.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<String>(archivedAt.value);
    }
    if (evaluatedAt.present) {
      map['evaluated_at'] = Variable<String>(evaluatedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<String>(closedAt.value);
    }
    if (isRemarkable.present) {
      map['is_remarkable'] = Variable<bool>(isRemarkable.value);
    }
    if (conversationStarted.present) {
      map['conversation_started'] = Variable<bool>(conversationStarted.value);
    }
    if (beingEvaluated.present) {
      map['being_evaluated'] = Variable<bool>(beingEvaluated.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (showInGeneral.present) {
      map['show_in_general'] = Variable<bool>(showInGeneral.value);
    }
    if (showInRemarkable.present) {
      map['show_in_remarkable'] = Variable<bool>(showInRemarkable.value);
    }
    if (canCreateMessage.present) {
      map['can_create_message'] = Variable<bool>(canCreateMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecitationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('narrationId: $narrationId, ')
          ..write('verseIds: $verseIds, ')
          ..write('chapterId: $chapterId, ')
          ..write('record: $record, ')
          ..write('owner: $owner, ')
          ..write('ownerId: $ownerId, ')
          ..write('teacher: $teacher, ')
          ..write('gender: $gender, ')
          ..write('isChild: $isChild, ')
          ..write('isTeacherRecitation: $isTeacherRecitation, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('teacherRate: $teacherRate, ')
          ..write('ownerRate: $ownerRate, ')
          ..write('result: $result, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('evaluatedAt: $evaluatedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('isRemarkable: $isRemarkable, ')
          ..write('conversationStarted: $conversationStarted, ')
          ..write('beingEvaluated: $beingEvaluated, ')
          ..write('isClosed: $isClosed, ')
          ..write('showInGeneral: $showInGeneral, ')
          ..write('showInRemarkable: $showInRemarkable, ')
          ..write('canCreateMessage: $canCreateMessage')
          ..write(')'))
        .toString();
  }
}

class $FavoriteVersesTable extends FavoriteVerses
    with TableInfo<$FavoriteVersesTable, FavoriteVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteVersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idFromVerseMeta =
      const VerificationMeta('idFromVerse');
  @override
  late final GeneratedColumn<int> idFromVerse = GeneratedColumn<int>(
      'id_from_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idToVerseMeta =
      const VerificationMeta('idToVerse');
  @override
  late final GeneratedColumn<int> idToVerse = GeneratedColumn<int>(
      'id_to_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idPageMeta = const VerificationMeta('idPage');
  @override
  late final GeneratedColumn<int> idPage = GeneratedColumn<int>(
      'id_page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textFristVerseMeta =
      const VerificationMeta('textFristVerse');
  @override
  late final GeneratedColumn<String> textFristVerse = GeneratedColumn<String>(
      'text_frist_verse', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idFromVerse, idToVerse, idPage, userId, pageNumber, textFristVerse];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_verses';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteVerse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_from_verse')) {
      context.handle(
          _idFromVerseMeta,
          idFromVerse.isAcceptableOrUnknown(
              data['id_from_verse']!, _idFromVerseMeta));
    } else if (isInserting) {
      context.missing(_idFromVerseMeta);
    }
    if (data.containsKey('id_to_verse')) {
      context.handle(
          _idToVerseMeta,
          idToVerse.isAcceptableOrUnknown(
              data['id_to_verse']!, _idToVerseMeta));
    } else if (isInserting) {
      context.missing(_idToVerseMeta);
    }
    if (data.containsKey('id_page')) {
      context.handle(_idPageMeta,
          idPage.isAcceptableOrUnknown(data['id_page']!, _idPageMeta));
    } else if (isInserting) {
      context.missing(_idPageMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('text_frist_verse')) {
      context.handle(
          _textFristVerseMeta,
          textFristVerse.isAcceptableOrUnknown(
              data['text_frist_verse']!, _textFristVerseMeta));
    } else if (isInserting) {
      context.missing(_textFristVerseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteVerse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idFromVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_from_verse'])!,
      idToVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_to_verse'])!,
      idPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_page'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      textFristVerse: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}text_frist_verse'])!,
    );
  }

  @override
  $FavoriteVersesTable createAlias(String alias) {
    return $FavoriteVersesTable(attachedDatabase, alias);
  }
}

class FavoriteVerse extends DataClass implements Insertable<FavoriteVerse> {
  final int id;
  final int idFromVerse;
  final int idToVerse;
  final int idPage;
  final int userId;
  final int pageNumber;
  final String textFristVerse;
  const FavoriteVerse(
      {required this.id,
      required this.idFromVerse,
      required this.idToVerse,
      required this.idPage,
      required this.userId,
      required this.pageNumber,
      required this.textFristVerse});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_from_verse'] = Variable<int>(idFromVerse);
    map['id_to_verse'] = Variable<int>(idToVerse);
    map['id_page'] = Variable<int>(idPage);
    map['user_id'] = Variable<int>(userId);
    map['page_number'] = Variable<int>(pageNumber);
    map['text_frist_verse'] = Variable<String>(textFristVerse);
    return map;
  }

  FavoriteVersesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteVersesCompanion(
      id: Value(id),
      idFromVerse: Value(idFromVerse),
      idToVerse: Value(idToVerse),
      idPage: Value(idPage),
      userId: Value(userId),
      pageNumber: Value(pageNumber),
      textFristVerse: Value(textFristVerse),
    );
  }

  factory FavoriteVerse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteVerse(
      id: serializer.fromJson<int>(json['id']),
      idFromVerse: serializer.fromJson<int>(json['idFromVerse']),
      idToVerse: serializer.fromJson<int>(json['idToVerse']),
      idPage: serializer.fromJson<int>(json['idPage']),
      userId: serializer.fromJson<int>(json['userId']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      textFristVerse: serializer.fromJson<String>(json['textFristVerse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idFromVerse': serializer.toJson<int>(idFromVerse),
      'idToVerse': serializer.toJson<int>(idToVerse),
      'idPage': serializer.toJson<int>(idPage),
      'userId': serializer.toJson<int>(userId),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'textFristVerse': serializer.toJson<String>(textFristVerse),
    };
  }

  FavoriteVerse copyWith(
          {int? id,
          int? idFromVerse,
          int? idToVerse,
          int? idPage,
          int? userId,
          int? pageNumber,
          String? textFristVerse}) =>
      FavoriteVerse(
        id: id ?? this.id,
        idFromVerse: idFromVerse ?? this.idFromVerse,
        idToVerse: idToVerse ?? this.idToVerse,
        idPage: idPage ?? this.idPage,
        userId: userId ?? this.userId,
        pageNumber: pageNumber ?? this.pageNumber,
        textFristVerse: textFristVerse ?? this.textFristVerse,
      );
  @override
  String toString() {
    return (StringBuffer('FavoriteVerse(')
          ..write('id: $id, ')
          ..write('idFromVerse: $idFromVerse, ')
          ..write('idToVerse: $idToVerse, ')
          ..write('idPage: $idPage, ')
          ..write('userId: $userId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('textFristVerse: $textFristVerse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, idFromVerse, idToVerse, idPage, userId, pageNumber, textFristVerse);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteVerse &&
          other.id == this.id &&
          other.idFromVerse == this.idFromVerse &&
          other.idToVerse == this.idToVerse &&
          other.idPage == this.idPage &&
          other.userId == this.userId &&
          other.pageNumber == this.pageNumber &&
          other.textFristVerse == this.textFristVerse);
}

class FavoriteVersesCompanion extends UpdateCompanion<FavoriteVerse> {
  final Value<int> id;
  final Value<int> idFromVerse;
  final Value<int> idToVerse;
  final Value<int> idPage;
  final Value<int> userId;
  final Value<int> pageNumber;
  final Value<String> textFristVerse;
  const FavoriteVersesCompanion({
    this.id = const Value.absent(),
    this.idFromVerse = const Value.absent(),
    this.idToVerse = const Value.absent(),
    this.idPage = const Value.absent(),
    this.userId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.textFristVerse = const Value.absent(),
  });
  FavoriteVersesCompanion.insert({
    this.id = const Value.absent(),
    required int idFromVerse,
    required int idToVerse,
    required int idPage,
    required int userId,
    required int pageNumber,
    required String textFristVerse,
  })  : idFromVerse = Value(idFromVerse),
        idToVerse = Value(idToVerse),
        idPage = Value(idPage),
        userId = Value(userId),
        pageNumber = Value(pageNumber),
        textFristVerse = Value(textFristVerse);
  static Insertable<FavoriteVerse> custom({
    Expression<int>? id,
    Expression<int>? idFromVerse,
    Expression<int>? idToVerse,
    Expression<int>? idPage,
    Expression<int>? userId,
    Expression<int>? pageNumber,
    Expression<String>? textFristVerse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idFromVerse != null) 'id_from_verse': idFromVerse,
      if (idToVerse != null) 'id_to_verse': idToVerse,
      if (idPage != null) 'id_page': idPage,
      if (userId != null) 'user_id': userId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (textFristVerse != null) 'text_frist_verse': textFristVerse,
    });
  }

  FavoriteVersesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idFromVerse,
      Value<int>? idToVerse,
      Value<int>? idPage,
      Value<int>? userId,
      Value<int>? pageNumber,
      Value<String>? textFristVerse}) {
    return FavoriteVersesCompanion(
      id: id ?? this.id,
      idFromVerse: idFromVerse ?? this.idFromVerse,
      idToVerse: idToVerse ?? this.idToVerse,
      idPage: idPage ?? this.idPage,
      userId: userId ?? this.userId,
      pageNumber: pageNumber ?? this.pageNumber,
      textFristVerse: textFristVerse ?? this.textFristVerse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idFromVerse.present) {
      map['id_from_verse'] = Variable<int>(idFromVerse.value);
    }
    if (idToVerse.present) {
      map['id_to_verse'] = Variable<int>(idToVerse.value);
    }
    if (idPage.present) {
      map['id_page'] = Variable<int>(idPage.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (textFristVerse.present) {
      map['text_frist_verse'] = Variable<String>(textFristVerse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteVersesCompanion(')
          ..write('id: $id, ')
          ..write('idFromVerse: $idFromVerse, ')
          ..write('idToVerse: $idToVerse, ')
          ..write('idPage: $idPage, ')
          ..write('userId: $userId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('textFristVerse: $textFristVerse')
          ..write(')'))
        .toString();
  }
}

class $FavoritePagesTable extends FavoritePages
    with TableInfo<$FavoritePagesTable, FavoritePage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritePagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idPageMeta = const VerificationMeta('idPage');
  @override
  late final GeneratedColumn<int> idPage = GeneratedColumn<int>(
      'id_page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idBookMeta = const VerificationMeta('idBook');
  @override
  late final GeneratedColumn<int> idBook = GeneratedColumn<int>(
      'id_book', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textVerseMeta =
      const VerificationMeta('textVerse');
  @override
  late final GeneratedColumn<String> textVerse = GeneratedColumn<String>(
      'text_verse', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idPage, idBook, pageNumber, userId, textVerse];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_pages';
  @override
  VerificationContext validateIntegrity(Insertable<FavoritePage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_page')) {
      context.handle(_idPageMeta,
          idPage.isAcceptableOrUnknown(data['id_page']!, _idPageMeta));
    } else if (isInserting) {
      context.missing(_idPageMeta);
    }
    if (data.containsKey('id_book')) {
      context.handle(_idBookMeta,
          idBook.isAcceptableOrUnknown(data['id_book']!, _idBookMeta));
    } else if (isInserting) {
      context.missing(_idBookMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('text_verse')) {
      context.handle(_textVerseMeta,
          textVerse.isAcceptableOrUnknown(data['text_verse']!, _textVerseMeta));
    } else if (isInserting) {
      context.missing(_textVerseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoritePage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritePage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_page'])!,
      idBook: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_book'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      textVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_verse'])!,
    );
  }

  @override
  $FavoritePagesTable createAlias(String alias) {
    return $FavoritePagesTable(attachedDatabase, alias);
  }
}

class FavoritePagesCompanion extends UpdateCompanion<FavoritePage> {
  final Value<int> id;
  final Value<int> idPage;
  final Value<int> idBook;
  final Value<int> pageNumber;
  final Value<int> userId;
  final Value<String> textVerse;
  const FavoritePagesCompanion({
    this.id = const Value.absent(),
    this.idPage = const Value.absent(),
    this.idBook = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.userId = const Value.absent(),
    this.textVerse = const Value.absent(),
  });
  FavoritePagesCompanion.insert({
    this.id = const Value.absent(),
    required int idPage,
    required int idBook,
    required int pageNumber,
    required int userId,
    required String textVerse,
  })  : idPage = Value(idPage),
        idBook = Value(idBook),
        pageNumber = Value(pageNumber),
        userId = Value(userId),
        textVerse = Value(textVerse);
  static Insertable<FavoritePage> custom({
    Expression<int>? id,
    Expression<int>? idPage,
    Expression<int>? idBook,
    Expression<int>? pageNumber,
    Expression<int>? userId,
    Expression<String>? textVerse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idPage != null) 'id_page': idPage,
      if (idBook != null) 'id_book': idBook,
      if (pageNumber != null) 'page_number': pageNumber,
      if (userId != null) 'user_id': userId,
      if (textVerse != null) 'text_verse': textVerse,
    });
  }

  FavoritePagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idPage,
      Value<int>? idBook,
      Value<int>? pageNumber,
      Value<int>? userId,
      Value<String>? textVerse}) {
    return FavoritePagesCompanion(
      id: id ?? this.id,
      idPage: idPage ?? this.idPage,
      idBook: idBook ?? this.idBook,
      pageNumber: pageNumber ?? this.pageNumber,
      userId: userId ?? this.userId,
      textVerse: textVerse ?? this.textVerse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idPage.present) {
      map['id_page'] = Variable<int>(idPage.value);
    }
    if (idBook.present) {
      map['id_book'] = Variable<int>(idBook.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (textVerse.present) {
      map['text_verse'] = Variable<String>(textVerse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePagesCompanion(')
          ..write('id: $id, ')
          ..write('idPage: $idPage, ')
          ..write('idBook: $idBook, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('userId: $userId, ')
          ..write('textVerse: $textVerse')
          ..write(')'))
        .toString();
  }
}

class $LocalRecitationsTable extends LocalRecitations
    with TableInfo<$LocalRecitationsTable, LocalRecitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRecitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _narrationIdMeta =
      const VerificationMeta('narrationId');
  @override
  late final GeneratedColumn<int> narrationId = GeneratedColumn<int>(
      'narration_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recordMeta = const VerificationMeta('record');
  @override
  late final GeneratedColumn<String> record = GeneratedColumn<String>(
      'record', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versesListMeta =
      const VerificationMeta('versesList');
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> versesList =
      GeneratedColumn<String>('verses_list', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<int>>(
              $LocalRecitationsTable.$converterversesList);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedMeta =
      const VerificationMeta('uploaded');
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
      'uploaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("uploaded" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, narrationId, userId, chapterId, record, versesList, name, uploaded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_recitations';
  @override
  VerificationContext validateIntegrity(Insertable<LocalRecitation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('narration_id')) {
      context.handle(
          _narrationIdMeta,
          narrationId.isAcceptableOrUnknown(
              data['narration_id']!, _narrationIdMeta));
    } else if (isInserting) {
      context.missing(_narrationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('record')) {
      context.handle(_recordMeta,
          record.isAcceptableOrUnknown(data['record']!, _recordMeta));
    } else if (isInserting) {
      context.missing(_recordMeta);
    }
    context.handle(_versesListMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('uploaded')) {
      context.handle(_uploadedMeta,
          uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta));
    } else if (isInserting) {
      context.missing(_uploadedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalRecitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRecitation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      narrationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}narration_id'])!,
      record: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record'])!,
      versesList: $LocalRecitationsTable.$converterversesList.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}verses_list'])!),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      uploaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}uploaded'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $LocalRecitationsTable createAlias(String alias) {
    return $LocalRecitationsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $converterversesList =
      ListConverter();
}

class LocalRecitationsCompanion extends UpdateCompanion<LocalRecitation> {
  final Value<int> id;
  final Value<int> narrationId;
  final Value<int> userId;
  final Value<int> chapterId;
  final Value<String> record;
  final Value<List<int>> versesList;
  final Value<String> name;
  final Value<bool> uploaded;
  const LocalRecitationsCompanion({
    this.id = const Value.absent(),
    this.narrationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.record = const Value.absent(),
    this.versesList = const Value.absent(),
    this.name = const Value.absent(),
    this.uploaded = const Value.absent(),
  });
  LocalRecitationsCompanion.insert({
    this.id = const Value.absent(),
    required int narrationId,
    required int userId,
    required int chapterId,
    required String record,
    required List<int> versesList,
    required String name,
    required bool uploaded,
  })  : narrationId = Value(narrationId),
        userId = Value(userId),
        chapterId = Value(chapterId),
        record = Value(record),
        versesList = Value(versesList),
        name = Value(name),
        uploaded = Value(uploaded);
  static Insertable<LocalRecitation> custom({
    Expression<int>? id,
    Expression<int>? narrationId,
    Expression<int>? userId,
    Expression<int>? chapterId,
    Expression<String>? record,
    Expression<String>? versesList,
    Expression<String>? name,
    Expression<bool>? uploaded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (narrationId != null) 'narration_id': narrationId,
      if (userId != null) 'user_id': userId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (record != null) 'record': record,
      if (versesList != null) 'verses_list': versesList,
      if (name != null) 'name': name,
      if (uploaded != null) 'uploaded': uploaded,
    });
  }

  LocalRecitationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? narrationId,
      Value<int>? userId,
      Value<int>? chapterId,
      Value<String>? record,
      Value<List<int>>? versesList,
      Value<String>? name,
      Value<bool>? uploaded}) {
    return LocalRecitationsCompanion(
      id: id ?? this.id,
      narrationId: narrationId ?? this.narrationId,
      userId: userId ?? this.userId,
      chapterId: chapterId ?? this.chapterId,
      record: record ?? this.record,
      versesList: versesList ?? this.versesList,
      name: name ?? this.name,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (narrationId.present) {
      map['narration_id'] = Variable<int>(narrationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (record.present) {
      map['record'] = Variable<String>(record.value);
    }
    if (versesList.present) {
      map['verses_list'] = Variable<String>(
          $LocalRecitationsTable.$converterversesList.toSql(versesList.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecitationsCompanion(')
          ..write('id: $id, ')
          ..write('narrationId: $narrationId, ')
          ..write('userId: $userId, ')
          ..write('chapterId: $chapterId, ')
          ..write('record: $record, ')
          ..write('versesList: $versesList, ')
          ..write('name: $name, ')
          ..write('uploaded: $uploaded')
          ..write(')'))
        .toString();
  }
}

class $VerseNotesTable extends VerseNotes
    with TableInfo<$VerseNotesTable, VerseNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerseNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idFromVerseMeta =
      const VerificationMeta('idFromVerse');
  @override
  late final GeneratedColumn<int> idFromVerse = GeneratedColumn<int>(
      'id_from_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idToVerseMeta =
      const VerificationMeta('idToVerse');
  @override
  late final GeneratedColumn<int> idToVerse = GeneratedColumn<int>(
      'id_to_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idPageMeta = const VerificationMeta('idPage');
  @override
  late final GeneratedColumn<int> idPage = GeneratedColumn<int>(
      'id_page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textFristVerseMeta =
      const VerificationMeta('textFristVerse');
  @override
  late final GeneratedColumn<String> textFristVerse = GeneratedColumn<String>(
      'text_frist_verse', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _noteTextMeta =
      const VerificationMeta('noteText');
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
      'note_text', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        pageNumber,
        idFromVerse,
        idToVerse,
        idPage,
        textFristVerse,
        noteText
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_notes';
  @override
  VerificationContext validateIntegrity(Insertable<VerseNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('id_from_verse')) {
      context.handle(
          _idFromVerseMeta,
          idFromVerse.isAcceptableOrUnknown(
              data['id_from_verse']!, _idFromVerseMeta));
    } else if (isInserting) {
      context.missing(_idFromVerseMeta);
    }
    if (data.containsKey('id_to_verse')) {
      context.handle(
          _idToVerseMeta,
          idToVerse.isAcceptableOrUnknown(
              data['id_to_verse']!, _idToVerseMeta));
    } else if (isInserting) {
      context.missing(_idToVerseMeta);
    }
    if (data.containsKey('id_page')) {
      context.handle(_idPageMeta,
          idPage.isAcceptableOrUnknown(data['id_page']!, _idPageMeta));
    } else if (isInserting) {
      context.missing(_idPageMeta);
    }
    if (data.containsKey('text_frist_verse')) {
      context.handle(
          _textFristVerseMeta,
          textFristVerse.isAcceptableOrUnknown(
              data['text_frist_verse']!, _textFristVerseMeta));
    } else if (isInserting) {
      context.missing(_textFristVerseMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(_noteTextMeta,
          noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta));
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerseNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      idFromVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_from_verse'])!,
      idToVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_to_verse'])!,
      idPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_page'])!,
      textFristVerse: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}text_frist_verse'])!,
      noteText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_text'])!,
    );
  }

  @override
  $VerseNotesTable createAlias(String alias) {
    return $VerseNotesTable(attachedDatabase, alias);
  }
}

class VerseNote extends DataClass implements Insertable<VerseNote> {
  final int id;
  final int userId;
  final int pageNumber;
  final int idFromVerse;
  final int idToVerse;
  final int idPage;
  final String textFristVerse;
  final String noteText;
  const VerseNote(
      {required this.id,
      required this.userId,
      required this.pageNumber,
      required this.idFromVerse,
      required this.idToVerse,
      required this.idPage,
      required this.textFristVerse,
      required this.noteText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['page_number'] = Variable<int>(pageNumber);
    map['id_from_verse'] = Variable<int>(idFromVerse);
    map['id_to_verse'] = Variable<int>(idToVerse);
    map['id_page'] = Variable<int>(idPage);
    map['text_frist_verse'] = Variable<String>(textFristVerse);
    map['note_text'] = Variable<String>(noteText);
    return map;
  }

  VerseNotesCompanion toCompanion(bool nullToAbsent) {
    return VerseNotesCompanion(
      id: Value(id),
      userId: Value(userId),
      pageNumber: Value(pageNumber),
      idFromVerse: Value(idFromVerse),
      idToVerse: Value(idToVerse),
      idPage: Value(idPage),
      textFristVerse: Value(textFristVerse),
      noteText: Value(noteText),
    );
  }

  factory VerseNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseNote(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      idFromVerse: serializer.fromJson<int>(json['idFromVerse']),
      idToVerse: serializer.fromJson<int>(json['idToVerse']),
      idPage: serializer.fromJson<int>(json['idPage']),
      textFristVerse: serializer.fromJson<String>(json['textFristVerse']),
      noteText: serializer.fromJson<String>(json['noteText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'idFromVerse': serializer.toJson<int>(idFromVerse),
      'idToVerse': serializer.toJson<int>(idToVerse),
      'idPage': serializer.toJson<int>(idPage),
      'textFristVerse': serializer.toJson<String>(textFristVerse),
      'noteText': serializer.toJson<String>(noteText),
    };
  }

  VerseNote copyWith(
          {int? id,
          int? userId,
          int? pageNumber,
          int? idFromVerse,
          int? idToVerse,
          int? idPage,
          String? textFristVerse,
          String? noteText}) =>
      VerseNote(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        pageNumber: pageNumber ?? this.pageNumber,
        idFromVerse: idFromVerse ?? this.idFromVerse,
        idToVerse: idToVerse ?? this.idToVerse,
        idPage: idPage ?? this.idPage,
        textFristVerse: textFristVerse ?? this.textFristVerse,
        noteText: noteText ?? this.noteText,
      );
  @override
  String toString() {
    return (StringBuffer('VerseNote(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('idFromVerse: $idFromVerse, ')
          ..write('idToVerse: $idToVerse, ')
          ..write('idPage: $idPage, ')
          ..write('textFristVerse: $textFristVerse, ')
          ..write('noteText: $noteText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, pageNumber, idFromVerse,
      idToVerse, idPage, textFristVerse, noteText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseNote &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.pageNumber == this.pageNumber &&
          other.idFromVerse == this.idFromVerse &&
          other.idToVerse == this.idToVerse &&
          other.idPage == this.idPage &&
          other.textFristVerse == this.textFristVerse &&
          other.noteText == this.noteText);
}

class VerseNotesCompanion extends UpdateCompanion<VerseNote> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> pageNumber;
  final Value<int> idFromVerse;
  final Value<int> idToVerse;
  final Value<int> idPage;
  final Value<String> textFristVerse;
  final Value<String> noteText;
  const VerseNotesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.idFromVerse = const Value.absent(),
    this.idToVerse = const Value.absent(),
    this.idPage = const Value.absent(),
    this.textFristVerse = const Value.absent(),
    this.noteText = const Value.absent(),
  });
  VerseNotesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int pageNumber,
    required int idFromVerse,
    required int idToVerse,
    required int idPage,
    required String textFristVerse,
    required String noteText,
  })  : userId = Value(userId),
        pageNumber = Value(pageNumber),
        idFromVerse = Value(idFromVerse),
        idToVerse = Value(idToVerse),
        idPage = Value(idPage),
        textFristVerse = Value(textFristVerse),
        noteText = Value(noteText);
  static Insertable<VerseNote> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? pageNumber,
    Expression<int>? idFromVerse,
    Expression<int>? idToVerse,
    Expression<int>? idPage,
    Expression<String>? textFristVerse,
    Expression<String>? noteText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (idFromVerse != null) 'id_from_verse': idFromVerse,
      if (idToVerse != null) 'id_to_verse': idToVerse,
      if (idPage != null) 'id_page': idPage,
      if (textFristVerse != null) 'text_frist_verse': textFristVerse,
      if (noteText != null) 'note_text': noteText,
    });
  }

  VerseNotesCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? pageNumber,
      Value<int>? idFromVerse,
      Value<int>? idToVerse,
      Value<int>? idPage,
      Value<String>? textFristVerse,
      Value<String>? noteText}) {
    return VerseNotesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pageNumber: pageNumber ?? this.pageNumber,
      idFromVerse: idFromVerse ?? this.idFromVerse,
      idToVerse: idToVerse ?? this.idToVerse,
      idPage: idPage ?? this.idPage,
      textFristVerse: textFristVerse ?? this.textFristVerse,
      noteText: noteText ?? this.noteText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (idFromVerse.present) {
      map['id_from_verse'] = Variable<int>(idFromVerse.value);
    }
    if (idToVerse.present) {
      map['id_to_verse'] = Variable<int>(idToVerse.value);
    }
    if (idPage.present) {
      map['id_page'] = Variable<int>(idPage.value);
    }
    if (textFristVerse.present) {
      map['text_frist_verse'] = Variable<String>(textFristVerse.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseNotesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('idFromVerse: $idFromVerse, ')
          ..write('idToVerse: $idToVerse, ')
          ..write('idPage: $idPage, ')
          ..write('textFristVerse: $textFristVerse, ')
          ..write('noteText: $noteText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $RecitationsTable recitations = $RecitationsTable(this);
  late final $FavoriteVersesTable favoriteVerses = $FavoriteVersesTable(this);
  late final $FavoritePagesTable favoritePages = $FavoritePagesTable(this);
  late final $LocalRecitationsTable localRecitations =
      $LocalRecitationsTable(this);
  late final $VerseNotesTable verseNotes = $VerseNotesTable(this);
  late final VerseNotesDao verseNotesDao = VerseNotesDao(this as AppDatabase);
  late final FavoriteVersesDao favoriteVersesDao =
      FavoriteVersesDao(this as AppDatabase);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final FavoritePagesDao favoritePagesDao =
      FavoritePagesDao(this as AppDatabase);
  late final LocalRecitationsDao localRecitationsDao =
      LocalRecitationsDao(this as AppDatabase);
  late final RecitationsDao recitationsDao =
      RecitationsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        recitations,
        favoriteVerses,
        favoritePages,
        localRecitations,
        verseNotes
      ];
}

mixin _$VerseNotesDaoMixin on DatabaseAccessor<AppDatabase> {
  $VerseNotesTable get verseNotes => attachedDatabase.verseNotes;
}
mixin _$FavoriteVersesDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavoriteVersesTable get favoriteVerses => attachedDatabase.favoriteVerses;
}
mixin _$UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$FavoritePagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavoritePagesTable get favoritePages => attachedDatabase.favoritePages;
}
mixin _$LocalRecitationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalRecitationsTable get localRecitations =>
      attachedDatabase.localRecitations;
}
mixin _$RecitationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecitationsTable get recitations => attachedDatabase.recitations;
}
