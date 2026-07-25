import 'dart:convert';

class Fault {
  int id;
  String? faultType;
  String? errorText;
  int? positionFrom;
  int? positionTo;
  Fault({
    required this.id,
    this.faultType,
    this.errorText,
    this.positionFrom,
    this.positionTo,
  });

  Fault copyWith({
    int? id,
    String? faultType,
    String? errorText,
    int? positionFrom,
    int? positionTo,
  }) {
    return Fault(
      id: id ?? this.id,
      faultType: faultType ?? this.faultType,
      errorText: errorText ?? this.errorText,
      positionFrom: positionFrom ?? this.positionFrom,
      positionTo: positionTo ?? this.positionTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fault_type': faultType,
      'error_text': errorText,
      'position_from': positionFrom,
      'position_to': positionTo,
    };
  }

  factory Fault.fromMap(Map<String, dynamic> map) {
    return Fault(
      id: map['id']?.toInt() ?? 0,
      faultType: map['fault_type'],
      errorText: map['error_text'],
      positionFrom: map['position_from']?.toInt(),
      positionTo: map['position_to']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Fault.fromJson(String source) => Fault.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Fault(id: $id, faultType: $faultType, errorText: $errorText, positionFrom: $positionFrom, positionTo: $positionTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Fault &&
        other.id == id &&
        other.faultType == faultType &&
        other.errorText == errorText &&
        other.positionFrom == positionFrom &&
        other.positionTo == positionTo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        faultType.hashCode ^
        errorText.hashCode ^
        positionFrom.hashCode ^
        positionTo.hashCode;
  }
}
