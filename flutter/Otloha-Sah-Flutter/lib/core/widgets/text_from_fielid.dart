import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constant/utils.dart';
import '../utils/themes/color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextFormFieldApp extends StatelessWidget {
  const TextFormFieldApp({
    Key? key,
    required this.title,
    this.keyboardType = TextInputType.emailAddress,
    required this.validator,
    //required this.onSaved,
    this.controller,
    this.isPassword = false,
    this.isEnabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.value,
    this.padding,
    this.color,
    this.inputFormatters,
    this.minLines,
    this.contentPadding,
    this.focusNode,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  final bool isPassword;
  final bool isEnabled;
  final String title;
  final String? value;
  final double? padding;
  final TextInputType keyboardType;
  final List<FormFieldValidator<String>>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String?)? onChanged;

  // final Function(String?) onSaved;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? color;
  final int? minLines;
  final EdgeInsets? contentPadding;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0),
      child: FormBuilderTextField(
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        controller: controller,
        name: title,
        validator: FormBuilderValidators.compose(validator!),
        keyboardType: keyboardType,
        minLines: minLines ?? 1,
        maxLines: (minLines ?? 1) + 1,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          hintText: hintText,
          fillColor: Colors.blue.withOpacity(.0),
          filled: true,
          enabledBorder: border,
          focusedBorder: borderFocuse,
          errorBorder: border,
          focusedErrorBorder: borderFocuse,
          disabledBorder: border,
          labelStyle: const TextStyle(color: AppColor.txtGrey),
          labelText: title,
          contentPadding: contentPadding ?? const EdgeInsets.all(11),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
