import 'package:flutter/material.dart';

import '../utils/themes/color.dart';
import 'text_view.dart';

class ToolBarApp extends StatelessWidget {
  const ToolBarApp({
    Key? key,
    this.title,
    this.backIcon,
    this.actionIcon,
    this.titleWidget,
  }) : super(key: key);

  final Widget? backIcon;
  final Widget? actionIcon;
  final Widget? titleWidget;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backIcon ?? Container(),
          Expanded(
            child: titleWidget ??
                TextView(
                  text: title ?? '',
                  colorText: AppColor.txtColor3,
                  weightText: FontWeight.bold,
                ),
          ),
          actionIcon ?? Container(),
        ],
      ),
    );
  }
}
