import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/widgets/user_avatar_widget.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/utils/themes/color.dart';

class UserAppBar extends StatelessWidget {
  final User user;
  final bool isTyping;

  const UserAppBar({
    required this.user,
    required this.isTyping,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        UserAvatarWidget(
          user: user,
          radius: 18,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.fullname == ' ' || user.fullname!.isEmpty
                  ? user.username
                  : user.fullname!,
              style: TextStyle(
                color: AppColor.userNameColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (isTyping)
              const Text(
                'typing...',
                style: TextStyle(
                  color: AppColor.hidenBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
          ],
        ),
      ],
    );
  }
}
