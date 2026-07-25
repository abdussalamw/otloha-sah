import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReservationBottomSheet extends StatefulWidget {
  final Function(String examType, String? notes) onReserve;

  const ReservationBottomSheet({super.key, required this.onReserve});

  @override
  // ignore: library_private_types_in_public_api
  _ReservationBottomSheetState createState() => _ReservationBottomSheetState();
}

class _ReservationBottomSheetState extends State<ReservationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _examType;
  String? _notes;
  final List<String> _examTypes = ['level_exam', 'replacement_exam'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _examType,
              hint: Text(tr('Select Exam Type')),
              onChanged: (value) {
                setState(() {
                  _examType = value;
                });
              },
              items: _examTypes.map((examType) {
                return DropdownMenuItem<String>(
                  value: examType,
                  child: Text(tr(examType)),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return tr('Please select an exam type');
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _notes,
              decoration: InputDecoration(labelText: tr('Notes (Optional)')),
              maxLines: 3,
              onChanged: (value) {
                _notes = value;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onReserve(_examType!, _notes);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                tr('Reserve'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
