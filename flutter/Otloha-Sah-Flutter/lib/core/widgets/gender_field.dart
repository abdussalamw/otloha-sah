import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../utils/constant/utils.dart';
import '../utils/themes/color.dart';

class GenderField extends StatefulWidget {
  const GenderField({
    Key? key,
    required this.onChanged,
    this.initValue,
  }) : super(key: key);
  final Function(String? gender) onChanged;
  final String? initValue;

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<String>(
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      decoration: InputDecoration(
        labelText: tr('Gender'),
        labelStyle: const TextStyle(
          color: AppColor.txtGrey,
          height: 1,
        ),
        // isDense: true,
        // contentPadding: EdgeInsets.symmetric(horizontal: 60, vertical: 60),
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
      disabledHint: Text(
        tr('Select Gender'),
        style: const TextStyle(
          color: AppColor.backButtonColor,
          fontSize: 14,
          height: 1,
        ),
      ),
      items: genders
          .map((gender) => DropdownMenuItem(
              value: gender.toLowerCase(),
              child: Text(
                gender.tr(),
                style: const TextStyle(height: 1),
              )))
          .toList(),
      name: 'gender',
      initialValue: widget.initValue,
      onChanged: (value) =>
          widget.onChanged(genders[gendersView.indexOf(translate(value!))]),
    );
  }

  var genders = ['male', 'female'];

  var gendersView = [translate('male'), translate('female')];
}
