import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';

class BlockDialog extends StatelessWidget {
  const BlockDialog({
    super.key,
    required this.userId,
    required this.onBlock,
  });

  final int userId;
  final Function() onBlock;
  @override
  Widget build(BuildContext context) {
    return AlertPopup(
      alertType: AlertType.danger,
      message: tr('Are you sure you want to Block this user?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            onBlock();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              AppColor.white,
            ),
          ),
          child: Text(
            tr('Yes'),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            tr('No'),
            style: const TextStyle(
              color: AppColor.white,
            ),
          ),
        ),
      ],
    );
  }
}
