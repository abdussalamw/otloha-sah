import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/reserved_time_slots.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/timeslot_cubit/timeslot_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservedExamCard extends StatelessWidget {
  final ReservedTimeslot examReservation;

  const ReservedExamCard({
    super.key,
    required this.examReservation,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter =
        DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    final DateFormat timeFormatter =
        DateFormat.jm(Localizations.localeOf(context).toString());

    DateTime date = DateTime.parse(examReservation.calendarSlot.date);
    DateTime timeFrom = DateTime.parse(
        '${examReservation.calendarSlot.date} ${examReservation.calendarSlot.timeFrom}');
    DateTime timeTo = DateTime.parse(
        '${examReservation.calendarSlot.date} ${examReservation.calendarSlot.timeTo}');

    return BlocBuilder<TimeslotCubit, TimeSlotState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.assignment, color: Colors.grey[600]),
                    SizedBox(width: 8.0),
                    Text(
                      '${tr('Exam type')}: ${tr(examReservation.examType)}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.grey[600]),
                    SizedBox(width: 8.0),
                    Text(
                      '${tr('status')}: ${examReservation.status}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Wrap(
                  children: [
                    Icon(Icons.notes, color: Colors.grey[600]),
                    SizedBox(width: 8.0),
                    Text('${tr('notes')}: ',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    Text(
                      '${examReservation.notes ?? tr('none')}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.link, color: Colors.grey[600]),
                    SizedBox(width: 8.0),
                    InkWell(
                      onTap: () async {
                        final url =
                            Uri.parse(examReservation.meetingLink ?? '');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          // Could not launch URL, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(tr('Could not launch $url'))),
                          );
                        }
                      },
                      child: Text(
                        '${tr('meeting_link')}',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.grade, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      '${tr('level')}: ${examReservation.level.name.translate()}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (state.isReserved) ...[
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<TimeslotCubit>().cancelReservation(
                            examReservation: examReservation);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text(
                        tr('cancel'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
