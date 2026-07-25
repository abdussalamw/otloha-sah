import 'dart:convert';

class BaseProfile {
  final int id;
  final int khatma;
  final int? recitation;
  final String username;
  final String image;
  final String rate;
  final String languauge;
  final bool isTeacher;
  final String? favoriteTeacher;
  final String bio;
  final String level;
  final String phone;
  final bool? isCertified;
  BaseProfile({
    required this.id,
    required this.khatma,
    this.recitation,
    required this.username,
    required this.image,
    required this.rate,
    required this.languauge,
    required this.isTeacher,
    this.favoriteTeacher,
    required this.bio,
    required this.level,
    required this.phone,
    this.isCertified,
  });

  BaseProfile copyWith({
    int? id,
    int? khatma,
    int? recitation,
    String? username,
    String? image,
    String? rate,
    String? languauge,
    bool? isTeacher,
    String? favoriteTeacher,
    String? bio,
    String? level,
    String? phone,
    bool? isCertified,
  }) {
    return BaseProfile(
      id: id ?? this.id,
      khatma: khatma ?? this.khatma,
      recitation: recitation ?? this.recitation,
      username: username ?? this.username,
      image: image ?? this.image,
      rate: rate ?? this.rate,
      languauge: languauge ?? this.languauge,
      isTeacher: isTeacher ?? this.isTeacher,
      favoriteTeacher: favoriteTeacher ?? this.favoriteTeacher,
      bio: bio ?? this.bio,
      level: level ?? this.level,
      phone: phone ?? this.phone,
      isCertified: isCertified ?? this.isCertified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'khatma': khatma,
      'recitation': recitation,
      'username': username,
      'image': image,
      'rate': rate,
      'languauge': languauge,
      'isTeacher': isTeacher,
      'favoriteTeacher': favoriteTeacher,
      'bio': bio,
      'level': level,
      'phone': phone,
      'isCertified': isCertified,
    };
  }

  factory BaseProfile.fromMap(Map<String, dynamic> map) {
    return BaseProfile(
      id: map['id'] as int,
      khatma: map['khatma'] as int,
      recitation: map['recitation'] != null ? map['recitation'] as int : null,
      username: map['username'] as String,
      image: map['image'] as String,
      rate: map['rate'] as String,
      languauge: map['languauge'] as String,
      isTeacher: map['is_a_teacher'] ?? false,
      favoriteTeacher: map['favoriteTeacher'] != null
          ? map['favoriteTeacher'] as String
          : null,
      bio: map['bio'] as String,
      level: map['level'] as String,
      phone: map['phone'] as String,
      isCertified:
          map['isCertified'] != null ? map['isCertified'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseProfile.fromJson(String source) =>
      BaseProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BaseProfile(id: $id, khatma: $khatma, recitation: $recitation, username: $username, image: $image, rate: $rate, languauge: $languauge, is_a_teacher: $isTeacher, favoriteTeacher: $favoriteTeacher, bio: $bio, level: $level, phone: $phone, isCertified: $isCertified)';
  }

  @override
  bool operator ==(covariant BaseProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.khatma == khatma &&
        other.recitation == recitation &&
        other.username == username &&
        other.image == image &&
        other.rate == rate &&
        other.languauge == languauge &&
        other.isTeacher == isTeacher &&
        other.favoriteTeacher == favoriteTeacher &&
        other.bio == bio &&
        other.level == level &&
        other.phone == phone &&
        other.isCertified == isCertified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        khatma.hashCode ^
        recitation.hashCode ^
        username.hashCode ^
        image.hashCode ^
        rate.hashCode ^
        languauge.hashCode ^
        isTeacher.hashCode ^
        favoriteTeacher.hashCode ^
        bio.hashCode ^
        level.hashCode ^
        phone.hashCode ^
        isCertified.hashCode;
  }
}
