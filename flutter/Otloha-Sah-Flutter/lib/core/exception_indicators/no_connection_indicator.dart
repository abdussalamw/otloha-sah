import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'exception_indicator.dart';

/// Indicates that a connection error occurred.
class NoConnectionIndicator extends StatelessWidget {
  const NoConnectionIndicator({
    Key? key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: tr('No connection'),
        message: tr('Please check internet'),
        //assetName: 'assets/icons/frustrated-face.png',
        onTryAgain: onTryAgain,
      );
}
