import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/data_source/remote/tajweed_service.dart';

part 'timeslot_state.dart';

class TimeslotCubit extends Cubit<TimeSlotState> {
  TimeslotCubit(this.timeSlot, bool isReserved)
      : _tajweedService = TajweedService(),
        super(TimeSlotState(timeSlot: timeSlot, isReserved: isReserved));

  final TajweedService _tajweedService;
  final TimeSlot timeSlot;
  ReservedTimeslot? examReservation;

  Future<void> reserveSlot(int levelId, String examType, String? notes) async {
    await ExceptionHandling.hanleToastException(() async {
      examReservation = await _tajweedService
          .reserveTimeSlot(timeSlot.id, examType, levelId, notes: notes);
      emit(state.copyWith(
        timeSlot: timeSlot.copyWith(
          reservedSlots: timeSlot.reservedSlots + 1,
          remainingSlots: timeSlot.remainingSlots - 1,
        ),
        isReserved: true,
      ));
    }, tr('Reserved'), true);
  }

  Future<void> cancelReservation({ReservedTimeslot? examReservation}) async {
    await ExceptionHandling.hanleToastException(() async {
      var value = this.examReservation ?? examReservation;
      if (value != null) {
        await _tajweedService.cancelReservation(value.id);
        emit(state.copyWith(
          timeSlot: state.timeSlot.copyWith(
            reservedSlots: state.timeSlot.reservedSlots - 1,
            remainingSlots: state.timeSlot.remainingSlots + 1,
          ),
          isReserved: false,
        ));
        examReservation = null;
      }
    }, tr('Cancelled'), true);
  }
}
