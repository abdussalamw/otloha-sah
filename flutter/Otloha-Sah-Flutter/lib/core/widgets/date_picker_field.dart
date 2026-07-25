import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../utils/constant/utils.dart';
import '../utils/themes/color.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.initValue,
  }) : super(key: key);
  final TextEditingController controller;
  final Function(DateTime? value) onChanged;
  final String? initValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      inputType: InputType.date,
      initialValue: initValue != null ? DateTime.parse(initValue!) : null,
      controller: controller,
      format: DateFormat('yyyy-MM-dd', 'en'),
      decoration: InputDecoration(
        labelText: tr('Date of Birth'),
        labelStyle: const TextStyle(color: AppColor.lightBlue),
        isDense: true,
        enabledBorder: border,
        focusedBorder: borderFocuse,
        errorBorder: border,
        focusedErrorBorder: borderFocuse,
        disabledBorder: border,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.lightBlue,
            width: 10,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      name: 'date',
      onChanged: onChanged,
    );
  }
}
