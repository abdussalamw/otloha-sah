import 'dart:convert';

class StatisticsModel {
  final int narrationId;
  final int acceptedRecitations;
  final int rejectedRecitations;
  final int pendingRecitations;
  final int numberOfRecitations;

  StatisticsModel({
    required this.narrationId,
    required this.acceptedRecitations,
    required this.rejectedRecitations,
    required this.pendingRecitations,
    required this.numberOfRecitations,
  });

  StatisticsModel copyWith({
    int? narrationId,
    int? acceptedRecitations,
    int? rejectedRecitations,
    int? pendingRecitations,
    int? numberOfRecitations,
  }) {
    return StatisticsModel(
      narrationId: narrationId ?? this.narrationId,
      acceptedRecitations: acceptedRecitations ?? this.acceptedRecitations,
      rejectedRecitations: rejectedRecitations ?? this.rejectedRecitations,
      pendingRecitations: pendingRecitations ?? this.pendingRecitations,
      numberOfRecitations: numberOfRecitations ?? this.numberOfRecitations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'narration_id': narrationId,
      'accepted_recitations': acceptedRecitations,
      'rejected_recitations': rejectedRecitations,
      'pending_recitations': pendingRecitations,
      'number_of_recitations': numberOfRecitations,
    };
  }

  factory StatisticsModel.fromMap(Map<String, dynamic> map) {
    return StatisticsModel(
      narrationId: int.parse(map['narration_id']),
      acceptedRecitations: map['accepted_recitations'] ?? 0,
      rejectedRecitations: map['rejected_recitations'] ?? 0,
      pendingRecitations: map['pending_recitations'] ?? 0,
      numberOfRecitations: map['number_of_recitations'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsModel.fromJson(String source) =>
      StatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatisticsModel(narrationId: $narrationId, acceptedRecitations: $acceptedRecitations, rejectedRecitations: $rejectedRecitations, pendingRecitations: $pendingRecitations, numberOfRecitations: $numberOfRecitations)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatisticsModel &&
        other.narrationId == narrationId &&
        other.acceptedRecitations == acceptedRecitations &&
        other.rejectedRecitations == rejectedRecitations &&
        other.pendingRecitations == pendingRecitations &&
        other.numberOfRecitations == numberOfRecitations;
  }

  @override
  int get hashCode {
    return narrationId.hashCode ^
        acceptedRecitations.hashCode ^
        rejectedRecitations.hashCode ^
        pendingRecitations.hashCode ^
        numberOfRecitations.hashCode;
  }
}
