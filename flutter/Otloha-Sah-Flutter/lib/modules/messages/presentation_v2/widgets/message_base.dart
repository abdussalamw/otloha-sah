import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/user_services_data.dart';
import '../../business_logic_v2/cubit/message_details_cubit.dart';
import '../pages/chating_page.dart';
import '../pages/evaluation_page.dart';
import 'recitation_rate.dart';
import 'recitation_result.dart';
import '../../../recitations/presentation/widget/recitation_meta_title.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class MessageBase extends StatelessWidget {
  const MessageBase({super.key, required this.room});

  final Room room;

  bool get isUnseen {
    return (room.lastMessage == null &&
            room.owner.id! != UserDataServices.instance.getUserId() &&
            !room.seenBy.contains(UserDataServices.instance.getUserId())) ||
        (room.lastMessage != null &&
            room.lastMessage!.user != UserDataServices.instance.getUserId() &&
            !room.lastMessage!.seenBy
                .contains(UserDataServices.instance.getUserId()));
  }

  User? get peer =>
      room.users.firstWhere((element) => element.id == room.peers.first);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await MessageDetailsCubit.get(context).setRecitation(room.recitation!);
        if (UserDataServices.instance.isATeacher &&
            room.recitation?.evaluatedAt == null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EvaluationPage(room: room)),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatingPage(room: room)),
          );
        }
        // RoomsCubit.get(context).getRooms(withLoading: false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 80.0,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isUnseen
                ? Color(ThemeCubit.isDark ? 0xFF323E40 : 0xffe0faff)
                : Color(ThemeCubit.isDark ? 0xFF272727 : 0xfff6f6f6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4),
                    child: CachedImage(
                      url: peer!.profileImage ?? Constants.userDemo,
                      raduis: 28,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MessageHeader(
                      room: room,
                      isUnseen: isUnseen,
                      peer: peer!,
                    ),
                    MessageBody(
                      room: room,
                      isUnseen: isUnseen,
                    ),
                    MessageFooter(room: room),
                  ],
                ),
              ),

              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       UserInfoView(
              //         isSeen: _getSeen,
              //         name: userName,
              //         source: source,
              //         date: date,
              //       ),
              //       if (!isReplayed)
              //         AyhaView(
              //           ayha: ayha,
              //           color: isSeen
              //               ? AppColor.userNameColor
              //               : AppColor.headTextColor,
              //         ),
              //       if (isReplayed)
              //         ReplayView(
              //           replayTime: replayTime,
              //           replay: replay,
              //           color: isSeen
              //               ? AppColor.userNameColor
              //               : AppColor.headTextColor,
              //           isSeen: isSeen,
              //         ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           if (isReplayed)
              //             AyhaView(
              //               ayha: ayha,
              //               color: AppColor.userNameColor,
              //               fontSize: 12,
              //             ),
              //           Text(
              //             ayhaInfo ?? 'سورة البقرة الأيه 6',
              //             style: TextStyle(
              //               color: AppColor.userNameColor,
              //               fontWeight: FontWeight.normal,
              //               fontSize: 12,
              //             ),
              //             textAlign: TextAlign.start,
              //           ),
              //           if (rate != null) RateView(rate: rate),
              //           if (recitationType != null)
              //             RecitationTypeView(recitationType: recitationType),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // CachedImage(
              //   url: image ?? Constants.userDemo,
              //   raduis: 24,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageHeader extends StatelessWidget {
  final bool isUnseen;
  final Room room;
  final User peer;

  const MessageHeader(
      {super.key,
      required this.room,
      required this.isUnseen,
      required this.peer});

  String getTimeFormat(String? date) {
    if (date == null) return '';
    return easy.DateFormat('dd MMM hh:mm').format(
      DateTime.parse(date),
    );
  }

  bool get isOutgoing {
    return room.lastMessage == null
        ? room.owner.id == UserDataServices.instance.getUserId()
        : room.lastMessage!.user == UserDataServices.instance.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    room.roomType == 'recitation'
                        ? (peer.fullname! == ' '
                            ? peer.username
                            : peer.fullname!)
                        : (room.name ?? peer.fullname!),
                    style: TextStyle(
                      color: AppColor.userNameColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                if (isUnseen)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF3A7BD5),
                          Color(0xFF00D2FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  room.lastMessage == null
                      ? getTimeFormat(room.createdAt)
                      : (room.lastMessage!.sentAt != 'not_sent'
                          ? getTimeFormat(room.lastMessage!.sentAt)
                          : translate('not_sent')),
                  style: TextStyle(
                      color: AppColor.userNameColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.2),
                ),
                const SizedBox(width: 4),
                RotatedBox(
                  quarterTurns: 1,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: !isOutgoing
                        ? Matrix4.rotationY(math.pi * 2)
                        : Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.reply,
                      size: 12,
                      color: AppColor.headTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class MessageBody extends StatelessWidget {
  const MessageBody({super.key, required this.room, required this.isUnseen});
  final Room room;
  final bool isUnseen;

  @override
  Widget build(BuildContext context) {
    if (room.lastMessage == null && room.roomType == 'recitation') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: AutoSizeText(
          room.recitation!.name ?? '',
          style: TextStyle(
            color: isUnseen ? AppColor.headTextColor : AppColor.userNameColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.2,
            fontFamily: Constants.fontFamily3,
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.start,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          if (room.lastMessage!.record != null)
            Container(
              // width: 50,
              // height: 16,
              decoration: const BoxDecoration(
                  // color:
                  //     isUnseen ? AppColor.headTextColor : AppColor.userNameColor,
                  ),
              child: Row(
                children: [
                  Icon(
                    Icons.mic,
                    color: isUnseen
                        ? AppColor.headTextColor
                        : AppColor.userNameColor,
                    size: 14,
                  ),
                  AutoSizeText(
                    room.lastMessage!.record!.duration!.split('.')[0],
                    style: TextStyle(
                      color: isUnseen
                          ? AppColor.headTextColor
                          : AppColor.userNameColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                      fontFamily: Constants.fontFamily3,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          const SizedBox(width: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width - 200,
            height: 15,
            child: AutoSizeText(
              room.lastMessage!.text ?? '',
              style: TextStyle(
                color:
                    isUnseen ? AppColor.headTextColor : AppColor.userNameColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.2,
                fontFamily: Constants.fontFamily3,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageFooter extends StatelessWidget {
  const MessageFooter({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    if (room.roomType == 'recitation') {
      if (room.lastMessage != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: AutoSizeText(
                  room.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.userNameColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                    fontFamily: Constants.fontFamily3,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              if (room.recitation != null)
                RecitationRate(rate: room.recitation!.teacherRate!),
              if (room.recitation != null && room.recitation!.result != null)
                RecitationResult(result: room.recitation!.result!),
              if (room.recitation!.evaluatedAt == null)
                RecitationMetaTitle(
                  recitation: room.recitation!,
                  options: const [
                    RecitationMetaTitleOptions.chapter,
                    // RecitationMetaTitleOptions.verses,
                  ],
                )
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: RecitationMetaTitle(
                recitation: room.recitation!,
                options: const [
                  RecitationMetaTitleOptions.chapter,
                  // RecitationMetaTitleOptions.verses,
                ],
              ),
            ),
            if (room.recitation != null)
              RecitationRate(rate: room.recitation!.teacherRate!),
            if (room.recitation != null && room.recitation!.result != null)
              RecitationResult(result: room.recitation!.result!),
          ],
        ),
      );
    }
    return Container();
  }
}

class RateView extends StatelessWidget {
  const RateView({
    super.key,
    required this.rate,
  });

  final double? rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          (rate ?? 4.5).toString(),
          style: const TextStyle(
            color: AppColor.lightYellow,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          textAlign: TextAlign.start,
        ),
        const Icon(
          Icons.star_outline,
          size: 14,
          color: AppColor.lightYellow,
        ),
      ],
    );
  }
}

class RecitationTypeView extends StatelessWidget {
  const RecitationTypeView({
    super.key,
    required this.recitationType,
  });

  final RecitationType? recitationType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          (recitationType == RecitationType.reject)
              ? translate('MarkasReject')
              : translate('MarkableRecitations'),
          style: TextStyle(
            color: (recitationType == RecitationType.mark)
                ? AppColor.lightBlue
                : (recitationType == RecitationType.accept)
                    ? AppColor.lightBlue
                    : AppColor.txtColor5,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(width: 1),
        if (recitationType == RecitationType.reject)
          const Icon(
            Icons.clear,
            size: 12,
            color: AppColor.txtColor5,
          ),
        if (recitationType == RecitationType.mark)
          SvgPicture.asset(
            AppSVG.markable,
            width: 8,
            height: 8,
            color: AppColor.lightBlue,
          ),
      ],
    );
  }
}

class ReplayView extends StatelessWidget {
  const ReplayView({
    super.key,
    required this.replayTime,
    required this.replay,
    required this.color,
    required this.isSeen,
  });

  final String? replayTime;
  final String? replay;
  final Color color;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (replayTime != null)
          SvgPicture.asset(
            isSeen ? AppSVG.mic : AppSVG.mic,
            width: 8,
            height: 6,
            color: color,
          ),
        if (replayTime != null) const SizedBox(width: 2),
        if (replayTime != null)
          Text(
            replayTime ?? '00:41',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: TextAlign.start,
          ),
        if (replayTime != null) const SizedBox(width: 8),
        Expanded(
          child: Text(
            replay ?? 'هناك خطأ في كلمة كفروا هناك خطأ في كلمة كفروا',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class AyhaView extends StatelessWidget {
  const AyhaView({Key? key, required this.ayha, this.color, this.fontSize})
      : super(key: key);

  final String? ayha;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      ayha ?? 'إِنَّ ٱلَّذِينَ كَفَرُواْ سَوَآءٌ عَلَيۡهِمۡ ءَأَنذَرۡتَهُمۡ',
      style: TextStyle(
        color: color ?? AppColor.headTextColor,
        fontWeight: FontWeight.w500,
        fontSize: fontSize ?? 18,
        fontFamily: Constants.fontFamily3,
      ),
      textAlign: TextAlign.start,
    );
  }
}

class UserInfoView extends StatelessWidget {
  const UserInfoView({
    Key? key,
    required this.isSeen,
    required this.name,
    required this.date,
    required this.source,
  }) : super(key: key);

  final bool isSeen;
  final String? name;
  final String? date;
  final Source source;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              (source == Source.outgoing)
                  ? AppSVG.outgoing
                  : AppSVG.incoming, //todo change image
              width: 12,
              height: 12,
              color: AppColor.headTextColor,
            ),
            const SizedBox(width: 3),
            Text(
              date ?? '15 Nov 9:30',
              style: TextStyle(
                color: AppColor.userNameColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              name ?? 'Mohamed Ahmed',
              style: TextStyle(
                color: AppColor.userNameColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (!isSeen) const SizedBox(width: 3),
            if (!isSeen)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: const [
                      AppColor.gradient2,
                      AppColor.gradient3,
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

enum Source {
  incoming,
  outgoing,
}

enum RecitationType {
  mark,
  reject,
  accept,
}

//incoming_new_thread_unseen.dart
//IncomingNewThreadUnseen

// incoming_reply_unseen.dart
// IncomingReplyUnseen

//incoming_new_thread_seen.dart
//IncomingNewThreadSeen

// incoming_reply_seen.dart
// IncomingReplySeen

// outgoing_replyunseen.dart
// OutgoingReplyUnseen

// outgoing_reply_seen.dart
// OutgoingReplySeen

// outgoing_new_thread_unseen.dart
// OutgoingNewThreadUnseen

// outgoing_new_thread_seen.dart
// OutgoingNewThreadSeen
