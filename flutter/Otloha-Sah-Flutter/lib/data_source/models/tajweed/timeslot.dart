class TimeSlot {
  final int id;
  final String date;
  final String timeFrom;
  final String timeTo;
  final int availableSlots;
  final int reservedSlots;
  final int remainingSlots;

  const TimeSlot({
    required this.id,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.availableSlots,
    required this.reservedSlots,
    required this.remainingSlots,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      date: json['date'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      availableSlots: json['available_slots'],
      reservedSlots: json['reserved_slots'],
      remainingSlots: json['remaining_slots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time_from': timeFrom,
      'time_to': timeTo,
      'available_slots': availableSlots,
      'reserved_slots': reservedSlots,
      'remaining_slots': remainingSlots,
    };
  }

  @override
  String toString() {
    return 'TimeSlot(id: $id, date: $date, timeFrom: $timeFrom, timeTo: $timeTo, availableSlots: $availableSlots, reservedSlots: $reservedSlots, remainingSlots: $remainingSlots)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.id == id &&
        other.date == date &&
        other.timeFrom == timeFrom &&
        other.timeTo == timeTo &&
        other.availableSlots == availableSlots &&
        other.reservedSlots == reservedSlots &&
        other.remainingSlots == remainingSlots;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        timeFrom.hashCode ^
        timeTo.hashCode ^
        availableSlots.hashCode ^
        reservedSlots.hashCode ^
        remainingSlots.hashCode;
  }

  TimeSlot copyWith({
    int? id,
    String? date,
    String? timeFrom,
    String? timeTo,
    int? availableSlots,
    int? reservedSlots,
    int? remainingSlots,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      date: date ?? this.date,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      availableSlots: availableSlots ?? this.availableSlots,
      reservedSlots: reservedSlots ?? this.reservedSlots,
      remainingSlots: remainingSlots ?? this.remainingSlots,
    );
  }
}
