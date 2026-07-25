import 'package:flutter/material.dart';

class ValidationErrorText extends StatelessWidget {
  final String error;
  const ValidationErrorText({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:5),
        child: (error!='')?Text(
          error,
          style: const TextStyle(
            height: 1,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ):const SizedBox(height: 0),
      ),
    );
  }
}