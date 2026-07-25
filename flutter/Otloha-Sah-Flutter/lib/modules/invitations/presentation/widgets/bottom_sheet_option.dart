import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';

class BottomSheetOption extends StatelessWidget {
  const BottomSheetOption({
    super.key,
    this.dialog,
    this.onTap,
    required this.optTitle,
  }) : assert(dialog != null || onTap != null);

  final Widget? dialog;
  final Function()? onTap;
  final String optTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Row(
              children: [
                Text(
                  optTitle,
                  style: const TextStyle(
                    color: AppColor.txtGrayColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            if (dialog == null && onTap != null) {
              onTap!();
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return dialog!;
                },
              );
            }
          },
        ),
        const Divider(color: AppColor.lightGrey),
      ],
    );
  }
}
