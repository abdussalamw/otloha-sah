import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../error/exceptions.dart';
import 'exception_indicator.dart';
import 'generic_error_indicator.dart';
import 'no_connection_indicator.dart';

/// Based on the received error, displays either a [NoConnectionIndicator] or
/// a [GenericErrorIndicator].
class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    required this.error,
    this.onTryAgain,
    Key? key,
  })  : assert(error != null),
        super(key: key);

  final dynamic error;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    if (error is NetworkConnectionException) {
      return NoConnectionIndicator(
        onTryAgain: onTryAgain,
      );
    } else if (error is EmptyListException) {
      return ExceptionIndicator(
        onTryAgain: onTryAgain,
        //assetName: AppIcons.emptyIcon,
        title: tr('No Data Found'),
      );
    } else {
      return GenericErrorIndicator(
        onTryAgain: onTryAgain,
      );
    }
  }
}
