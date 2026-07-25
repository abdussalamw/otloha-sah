import 'package:flutter/material.dart';
import '../../utils/themes/color.dart';

class WarningMessage extends StatelessWidget {
  const WarningMessage({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          color: AppColor.warningIconColor,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: AppColor.txtGrayColor),
          ),
        )
      ],
    );
  }
}
