import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'exception_indicator.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    Key? key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: tr('Something went wrong'),
        message: tr('The application has encountered an unknown error'),
      //  assetName: 'assets//icons/confused-face.png',
        onTryAgain: onTryAgain,
      );
}
