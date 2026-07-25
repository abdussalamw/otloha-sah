import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RecitationResult extends StatelessWidget {
  const RecitationResult({Key? key, required this.result}) : super(key: key);
  final String result;
  @override
  Widget build(BuildContext context) {
    if (result == 'accepted') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            color: Colors.green,
            size: 15,
          ),
          Text(tr('accepted')),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.close,
          color: Colors.red,
          size: 15,
        ),
        Text(tr('rejected')),
      ],
    );
  }
}
