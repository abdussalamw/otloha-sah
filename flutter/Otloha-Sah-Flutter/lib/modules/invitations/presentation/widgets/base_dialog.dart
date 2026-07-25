import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    required this.msg,
    required this.onSubmit,
    required this.alertType,
  });

  final String msg;
  final Function() onSubmit;
  final AlertType alertType;
  @override
  Widget build(BuildContext context) {
    return AlertPopup(
      alertType: alertType,
      message: msg,
      hideBtn: true,
      actions: [
        ElevatedButton(
          onPressed: () {
            onSubmit();
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
            style: TextStyle(
              color: alertType == AlertType.danger
                  ? Colors.red
                  : AppColor.txtColor3,
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
