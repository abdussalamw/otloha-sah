import 'dart:convert';

class ExamReservation {
  final int id;
  final String examType;
  final String? notes;
  final int level;
  ExamReservation({
    required this.id,
    required this.examType,
    this.notes,
    required this.level,
  });

  ExamReservation copyWith({
    int? id,
    String? examType,
    String? notes,
    int? level,
  }) {
    return ExamReservation(
      id: id ?? this.id,
      examType: examType ?? this.examType,
      notes: notes ?? this.notes,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'examType': examType,
      'notes': notes,
      'level': level,
    };
  }

  factory ExamReservation.fromMap(Map<String, dynamic> map) {
    return ExamReservation(
      id: map['id'] as int,
      examType: map['exam_type'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
      level: map['level'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExamReservation.fromJson(String source) =>
      ExamReservation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExamReservation(id: $id, examType: $examType, notes: $notes, level: $level)';
  }

  @override
  bool operator ==(covariant ExamReservation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.examType == examType &&
        other.notes == notes &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^ examType.hashCode ^ notes.hashCode ^ level.hashCode;
  }
}
