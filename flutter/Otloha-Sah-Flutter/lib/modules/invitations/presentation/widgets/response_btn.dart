import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';

class ResponseBtn extends StatelessWidget {
  const ResponseBtn({
    super.key,
    required this.username,
    required this.inFriend,
    required this.inSupervision,
    required this.onAcceptFriendRequest,
    required this.onAcceptSupervisionRequest,
    required this.onRejectFriendRequest,
    required this.onRejectSupervisionRequest,
  });

  final String username;
  final bool inFriend;
  final bool inSupervision;
  final Function() onAcceptFriendRequest;
  final Function() onAcceptSupervisionRequest;
  final Function() onRejectFriendRequest;
  final Function() onRejectSupervisionRequest;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 100 + (inFriend ? 75 : 0) + (inSupervision ? 75 : 0),
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: AppColor.txtColor3,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: AppColor.lightGrey),
                if (inFriend)
                  RespondOption(
                    action: onAcceptFriendRequest,
                    title: tr('Accept friend request'),
                  ),
                if (inFriend)
                  RespondOption(
                    action: onRejectFriendRequest,
                    title: tr('Reject friend request'),
                  ),
                if (inSupervision)
                  RespondOption(
                    action: onAcceptSupervisionRequest,
                    title: tr('Accept to be favorite teacher'),
                  ),
                if (inSupervision)
                  RespondOption(
                    action: onRejectSupervisionRequest,
                    title: tr('Reject to be favorite teacher'),
                  ),
              ],
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        tr('Respond'),
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}

class RespondOption extends StatelessWidget {
  const RespondOption({
    super.key,
    required this.action,
    required this.title,
  });

  final Function() action;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            action();
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.txtGrayColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: AppColor.lightGrey),
      ],
    );
  }
}
