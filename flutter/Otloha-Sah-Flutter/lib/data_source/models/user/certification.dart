import 'dart:convert';

class Certification {
  final int id;
  final int narration;
  final bool isCertified;
  final String? certification;
  final String? certifiedAt;
  final bool isCompelted;
  final double minCount;
  final int recitationCount;

  Certification({
    required this.id,
    required this.narration,
    required this.isCertified,
    required this.certification,
    required this.isCompelted,
    required this.minCount,
    required this.recitationCount,
    required this.certifiedAt,
  });

  Certification copyWith({
    int? id,
    int? narration,
    bool? isCertified,
    String? certification,
    bool? isCompelted,
    double? minCount,
    int? recitationCount,
  }) {
    return Certification(
      id: id ?? this.id,
      narration: narration ?? this.narration,
      isCertified: isCertified ?? this.isCertified,
      certification: certification ?? this.certification,
      isCompelted: isCompelted ?? this.isCompelted,
      minCount: minCount ?? this.minCount,
      recitationCount: recitationCount ?? this.recitationCount,
      certifiedAt: certifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'narration': narration,
      'is_certified': isCertified,
      'certification': certification,
      'is_compelted': isCompelted,
      'min_count': minCount,
      'recitations_count': recitationCount,
      'certified_at': certifiedAt,
    };
  }

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      id: map['id']?.toInt() ?? 0,
      narration: map['narration']?.toInt() ?? 0,
      isCertified: map['is_certified'] ?? false,
      certification: map['certification'] ?? '',
      isCompelted: map['is_compelted'] ?? false,
      minCount: map['min_count']?.toDouble() ?? 0.0,
      recitationCount: map['recitations_count']?.toInt() ?? 0,
      certifiedAt: map['certified_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Certification.fromJson(String source) =>
      Certification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Certification(id: $id, narration: $narration, isCertified: $isCertified, certification: $certification, isCompelted: $isCompelted, minCount: $minCount, recitationCount: $recitationCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Certification &&
        other.id == id &&
        other.narration == narration &&
        other.isCertified == isCertified &&
        other.certification == certification &&
        other.isCompelted == isCompelted &&
        other.minCount == minCount &&
        other.recitationCount == recitationCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        narration.hashCode ^
        isCertified.hashCode ^
        certification.hashCode ^
        isCompelted.hashCode ^
        minCount.hashCode ^
        recitationCount.hashCode;
  }
}
