import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';

class BottomSheetTitle extends StatelessWidget {
  const BottomSheetTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.txtColor3,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(color: AppColor.lightGrey),
      ],
    );
  }
}
