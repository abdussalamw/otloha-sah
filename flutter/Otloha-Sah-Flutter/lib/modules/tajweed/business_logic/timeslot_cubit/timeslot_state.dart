part of 'timeslot_cubit.dart';

class TimeSlotState extends Equatable {
  final TimeSlot timeSlot;
  final bool isReserved;

  const TimeSlotState({
    required this.timeSlot,
    this.isReserved = false,
  });

  TimeSlotState copyWith({
    TimeSlot? timeSlot,
    bool? isReserved,
  }) {
    return TimeSlotState(
      timeSlot: timeSlot ?? this.timeSlot,
      isReserved: isReserved ?? this.isReserved,
    );
  }

  @override
  List<Object?> get props => [timeSlot, isReserved];
}
