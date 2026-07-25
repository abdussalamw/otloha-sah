import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

class UserProgressIndicator extends StatelessWidget {
  const UserProgressIndicator({
    super.key,
    required this.user,
    required this.type,
    required this.value,
    this.fontSize = 12,
    this.width,
  });

  final User? user;
  final String type;
  final double value;
  final double fontSize;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * .25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView(
                padding: EdgeInsets.zero,
                text: type,
                sizeText: fontSize - 2,
                colorText: AppColor.txtColor3,
                textAlign: TextAlign.start,
              ),
              TextView(
                padding: EdgeInsets.zero,
                text: '${(value * 100).round()}%',
                sizeText: fontSize - 4,
                textAlign: TextAlign.start,
                colorText: AppColor.headTextColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 5.5,
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                child: LinearProgressIndicator(
                  value: value,
                  color: AppColor.proogTxtColor1,

                  // valueColor: const AlwaysStoppedAnimation<Color>(
                  //     AppColor.proogessColor1),
                  backgroundColor: AppColor.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
