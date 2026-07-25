import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';

class UnblockBtn extends StatelessWidget {
  const UnblockBtn({
    super.key,
    required this.onUnblock,
  });

  final Function() onUnblock;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onUnblock,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        tr('Unblock'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
