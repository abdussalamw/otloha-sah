import 'package:flutter/material.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

class UserLiked extends StatelessWidget {
  const UserLiked({
    Key? key,
    required this.userName,
    required this.userImage,
    this.note,
    this.action,
    required this.index,
    this.id,
    this.onDismissed,
    this.isTextHafs,
  }) : super(key: key);

  final String userName;
  final String userImage;
  final int index;
  final int? id;
  final String? note;
  final Function()? action;
  final Function(DismissDirection)? onDismissed;
  final bool? isTextHafs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Dismissible(
        onDismissed: onDismissed,
        key: UniqueKey(),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColor.transparent,
              width: 2,
            ),
            color: AppColor.backItem,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    userImage,
                    width: 48,
                    height: 48,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextView(
                    text: userName,
                    colorText: AppColor.txtColor3,
                    sizeText: 16,
                    weightText: FontWeight.bold,
                    textAlign: TextAlign.start,
                    fontFamily: (isTextHafs ?? false) ? 'Hafs20': '',
                  ),
                  if (note != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextView(
                        text: note ?? '',
                        colorText: AppColor.txtColor4,
                        sizeText: 14,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
