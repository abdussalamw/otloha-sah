import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../utils/constant/utils.dart';
import '../utils/themes/color.dart';

class PasswordFormField extends StatefulWidget {
  final String title;
  final TextEditingController? controller;
  final List<FormFieldValidator<String>>? validator;
  final Function(String? value)? onChange;
  final EdgeInsets? contentPadding;
  const PasswordFormField({
    Key? key,
    required this.title,
    this.controller,
    this.onChange,
    this.contentPadding,
    required this.validator,
  }) : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  var isPasswordMode = true;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: widget.controller,
      name: widget.title,
      validator: FormBuilderValidators.compose(
        widget.validator ?? [FormBuilderValidators.required()],
      ),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        isDense: true,
        fillColor: Colors.blue.withOpacity(.0),
        filled: true,
        enabledBorder: border,
        errorBorder: border,
        focusedBorder: borderFocuse,
        focusedErrorBorder: borderFocuse,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(10),
        disabledBorder: border,
        labelStyle: const TextStyle(color: AppColor.txtGrey),
        labelText: widget.title,
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            isPasswordMode = !isPasswordMode;
          }),
          icon: Icon(
            isPasswordMode
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: AppColor.lightBlue,
          ),
        ),
      ),
      obscureText: isPasswordMode,
      onChanged: widget.onChange,
    );
  }
}
