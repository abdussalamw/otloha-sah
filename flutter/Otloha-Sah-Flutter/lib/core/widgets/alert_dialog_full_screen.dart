import 'package:flutter/material.dart';
import '../utils/res/icons_app.dart';

import 'package:get/get.dart';

class AlertDialogFullScreen extends StatelessWidget {
  const AlertDialogFullScreen({
    Key? key,
    this.autoClose = true,
  }) : super(key: key);

  final bool autoClose;
  // final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    if (autoClose) {
      Future.delayed(
        const Duration(seconds: 1),
        Get.back,
      );
    }

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * .3),
      child: Image.asset(
        AppIcons.doneIcon,
        width: MediaQuery.of(context).size.width * .4,
        height: MediaQuery.of(context).size.width * .4,
      ),
    );
  }
}
