import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/timeslot.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/exam_reservation_bottom_sheet.dart';

class TimeSlotCard extends StatelessWidget {
  final TimeSlot timeSlot;

  const TimeSlotCard({
    super.key,
    required this.timeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeslotCubit(timeSlot, false),
      child: BlocBuilder<TimeslotCubit, TimeSlotState>(
        builder: (context, state) {
          final DateFormat dateFormatter =
              DateFormat.yMMMMd(Localizations.localeOf(context).toString());
          final DateFormat timeFormatter =
              DateFormat.jm(Localizations.localeOf(context).toString());

          DateTime date = DateTime.parse(state.timeSlot.date);
          DateTime timeFrom = DateTime.parse(
              '${state.timeSlot.date} ${state.timeSlot.timeFrom}');
          DateTime timeTo =
              DateTime.parse('${state.timeSlot.date} ${state.timeSlot.timeTo}');

          return Card(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 8.0),
                      Text(
                        dateFormatter.format(date),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600]),
                      SizedBox(width: 8.0),
                      Text(
                        '${timeFormatter.format(timeFrom)} - ${timeFormatter.format(timeTo)}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Divider(height: 20.0, thickness: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSlotInfo(context, tr('Available Slots'),
                          state.timeSlot.availableSlots, Colors.green),
                      _buildSlotInfo(context, tr('Remaining Slots'),
                          state.timeSlot.remainingSlots, Colors.orange),
                      _buildSlotInfo(context, tr('Reserved Slots'),
                          state.timeSlot.reservedSlots, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: state.isReserved
                        ? Column(
                            children: [
                              Text(
                                tr('Reserved'),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<TimeslotCubit>()
                                      .cancelReservation();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                child: Text(
                                  tr('Cancel'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: state.timeSlot.remainingSlots > 0
                                ? () {
                                    _showReserveBottomSheet(context);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              backgroundColor: Colors.blue,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: Text(
                              tr('Reserve'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotInfo(
      BuildContext context, String label, int count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: color),
        ),
        SizedBox(height: 4.0),
        Text(
          '$count',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showReserveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext cxt) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(cxt).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  tr('Reserve Exam Slot'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                ReservationBottomSheet(
                  onReserve: (String examType, String? notes) {
                    context.read<TimeslotCubit>().reserveSlot(
                          (context.read<LevelCardCubit>().state
                                  as LevelCardSelected)
                              .tajweedLevel
                              .id,
                          examType,
                          notes,
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
