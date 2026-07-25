import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../audio/presentation/wave_view.dart';

class MessageChatWidget extends StatelessWidget {
  MessageChatWidget({
    super.key,
    required this.message,
    required this.index,
    this.replyToMessage,
  });

  final MessageModel message;
  final int index;
  final DateFormat dateFormat = DateFormat('HH:mm');
  final MessageModel? replyToMessage;

  bool get isSender => message.user == UserDataServices.instance.getUserId();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: isSender ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            width: 270,
            margin: EdgeInsets.only(
              right: 14,
              left: 14,
              top: (message.fault != null ? 12 : 0) +
                  (message.fault != null ? 12 : 2),
              bottom: 2,
            ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: !isSender ? AppColor.messageColor2 : AppColor.messageColor,
              borderRadius: BorderRadius.only(
                bottomLeft: !isSender ? const Radius.circular(20) : Radius.zero,
                bottomRight:
                    !isSender ? Radius.zero : const Radius.circular(20),
                topLeft: !isSender ? Radius.zero : const Radius.circular(20),
                topRight: !isSender ? const Radius.circular(20) : Radius.zero,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.replyTo != null)
                  ReplyToMessage(
                    replyTo: replyToMessage!,
                    decoration: BoxDecoration(
                      color: !isSender
                          ? AppColor.messageColor2b
                          : AppColor.messageColorB,
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            !isSender ? const Radius.circular(4) : Radius.zero,
                        bottomRight:
                            !isSender ? Radius.zero : const Radius.circular(4),
                        topLeft:
                            !isSender ? Radius.zero : const Radius.circular(20),
                        topRight:
                            !isSender ? const Radius.circular(20) : Radius.zero,
                      ),
                    ),
                  ),
                if (message.fault != null && message.fault!.errorText != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Text(
                      message.fault!.errorText!,
                      style: AppStyle().textStyle1.copyWith(
                            fontSize: 16,
                            color: AppColor.headTextColor,
                            fontWeight: FontWeight.bold,
                            wordSpacing: .5,
                            fontFamily: 'Hafs17',
                          ),
                    ),
                  ),
                if (message.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: AppColor.userNameColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                if (message.record != null)
                  WaveViewPlayAudio(
                    isPlay: false,
                    record: message.record!,
                    wavePath: '',
                    right: 0,
                  ),
                Row(
                  children: [
                    Icon(
                      !message.isSent ? Icons.done : Icons.done_all,
                      size: 14,
                      color: !message.seenBy.contains(
                                  UserDataServices.instance.getUserId()) &&
                              message.seenBy.isNotEmpty
                          ? AppColor.headTextColor
                          : AppColor.userNameColor,
                    ),
                    Text(
                      dateFormat.format(DateTime.parse(message.sentAt)),
                      style: TextStyle(
                        color: AppColor.userNameColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (message.fault != null)
          Align(
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              margin: const EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColor.background,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1,
                ),
              ),
              child: Text(
                translate(message.fault!.faultType ?? ''),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.headTextColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ReplyToMessage extends StatelessWidget {
  const ReplyToMessage({
    super.key,
    required this.replyTo,
    required this.decoration,
    this.padding,
  });
  final MessageModel replyTo;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          if (replyTo.record?.duration != null)
            SvgPicture.asset(
              AppSVG.mic,
              width: 12,
              height: 12,
              color: AppColor.userNameColor,
            ),
          if (replyTo.record?.duration != null) const SizedBox(width: 4),
          if (replyTo.record?.duration != null)
            Text(
              replyTo.record?.duration ?? '',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.userNameColor,
              ),
            ),
          const SizedBox(width: 4),
          Text(
            (replyTo.text),
            style: TextStyle(
              fontSize: 12,
              color: AppColor.userNameColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageState {
  send,
  receive,
  read,
}

class ReplyMessage {
  final String? message;
  final String? time;
  const ReplyMessage({
    this.message,
    this.time,
  });
}
