import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/base_dialog.dart';

class UnfriendDialog extends StatelessWidget {
  const UnfriendDialog({
    super.key,
    required this.onSubmit,
  });

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      msg: tr('Are you sure you want to unfriend this user?'),
      alertType: AlertType.danger,
      onSubmit: onSubmit,
    );
  }
}
