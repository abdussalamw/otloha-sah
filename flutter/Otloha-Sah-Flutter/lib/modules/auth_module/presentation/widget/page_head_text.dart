import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

Widget pageLayOutTextHead(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 50, bottom: 50),
    child: TextView(
      text: title,
      sizeText: 24,
      weightText: FontWeight.bold,
      textAlign: TextAlign.center,
      colorText: AppColor.headTextColor,
    ),
  );
}
