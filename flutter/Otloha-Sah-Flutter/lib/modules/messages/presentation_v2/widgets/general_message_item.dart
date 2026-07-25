// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/modules/audio/presentation/wave_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../profile/presentation/page/profile_bnb_page.dart';
import '../../../profile/presentation/widget/user_name_view.dart';
import 'package:get/get.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import 'message_widget.dart';
import '../../../recitations/presentation/widget/popup_recitation.dart';
import '../../../recitations/presentation/widget/recitation_meta_title.dart';

class GeneralMessageItem extends StatefulWidget {
  const GeneralMessageItem({
    super.key,
    required this.recitation,
    this.isPlay = false,
    this.isLocal,
    this.toggelPlay,
    this.replay,
    this.recordPath,
    this.wavePath,
    this.userImage,
    this.id,
    this.owner,
    this.userName,
    this.dateStr,
    this.ayah,
    this.ayahInfo,
    this.color,
    this.onPress,
    this.userInfo,
    this.narrationName,
    this.isRead,
    this.isCertic,
    this.delete,
    this.hasMenu,
    this.typeUser = TypeUser.student,
  });

  final Recitation recitation;
  final TypeUser typeUser;
  final bool isPlay;
  final bool? isLocal;
  final Function()? toggelPlay;
  final Widget? replay;

  final String? recordPath;
  final String? wavePath;
  final String? userImage;

  final int? id;
  final User? owner;
  final String? userName;
  final String? dateStr;
  final String? ayah;
  final String? ayahInfo;
  final Color? color;
  final Function()? onPress;
  final Function()? delete;

  final String? userInfo;
  final String? narrationName;
  final bool? isRead;
  final bool? isCertic;
  final bool? hasMenu;

  @override
  State<GeneralMessageItem> createState() => _GeneralMessageItemState();
}

class _GeneralMessageItemState extends State<GeneralMessageItem> {
  // PlayerController controller = PlayerController();
  @override
  void initState() {
    // controller.preparePlayer(
    //     path: widget.recordPath!,
    //     noOfSamples: 100,
    //     shouldExtractWaveform: true);
    super.initState();
  }

  String getTimeFormat(String? date) {
    if (date == null) return '';
    return easy.DateFormat('dd MMM hh:mm').format(
      DateTime.parse(date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MessageWidget(
      onPress: onLongPress,
      userImage: InkWell(
        onTap: () {
          Get.to(
            () => ProfileBNBPage(user: widget.owner),
          );
        },
        child: CachedImage(url: widget.userImage ?? '', raduis: 36),
      ),
      userName: _viwName(),
      dataView: _viewData(),
      ayahView: _viewAyah(),
      ayahInfoView:
          RecitationMetaTitle(recitation: widget.recitation, options: const [
        RecitationMetaTitleOptions.narration,
        RecitationMetaTitleOptions.verses,
        RecitationMetaTitleOptions.chapter,
      ]),
      waveView: _waveView(),
      color: AppColor.selectColor1,
    );
  }

  Row _viewData() {
    return Row(
      children: [
        TextView(
          padding: EdgeInsets.zero,
          text: widget.dateStr?.toUpperCase() ?? '',
          sizeText: 10,
          colorText: AppColor.txtColor4,
        ),
        Text(
          getTimeFormat(widget.recitation.createdAt),
          style: TextStyle(
              color: AppColor.userNameColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.2),
        ),
        const Icon(
          Icons.bookmark_outline,
          size: 12,
          color: Colors.black,
        )
      ],
    );
  }

  _viwName() {
    return UserNameView(
      typeUser: widget.typeUser,
      child: InkWell(
        onTap: () {
          Get.to(
            () => ProfileBNBPage(user: widget.owner),
          );
        },
        child: Row(
          children: [
            TextView(
              text: widget.userName ?? easy.tr('Name'),
              weightText: FontWeight.w900,
              padding: EdgeInsets.zero,
              sizeText: 10,
              letterSpacing: 0.4,
              colorText: AppColor.userNameColor,
            ),
          ],
        ),
      ),
    );
  }

  _viewAyah() {
    if (widget.ayah!.contains('\n')) {
      widget.ayah!.replaceAll('\n', ' ');
    }
    return TextView(
      padding: EdgeInsets.zero,
      text: '${widget.id}- ${widget.ayah}',
      sizeText: 18,
      weightText: FontWeight.w900,
      colorText: AppColor.headTextColor,
      textAlign: TextAlign.start,
      fontFamily: 'Hafs20',
    );
  }

  _waveView() {
    return WaveViewPlayAudio(
      record: widget.recitation.record!,
      wavePath: widget.wavePath ?? '',
      isPlay: widget.isPlay,
    );
  }

  onLongPress() async {
    User? user = UserDataServices.instance.getUserDataFast();

    if (user != null && user.id == widget.owner!.id) {
      Get.bottomSheet(
        PopupRecitation(
          isLocal: false,
          actions: const [
            PopupActions.delete,
          ],
          isOwner: user.id == widget.owner!.id,
          isFinished: widget.dateStr?.isNotEmpty ?? false,
          recitationId: widget.id ?? 0,
          isTeacher: user.isTeacher,
          showInGeneral: true,
          delete: widget.delete,
          userId: widget.owner!.id,
        ),
      );
    }

    if (user != null &&
        user.id != widget.owner!.id &&
        user.isTeacher &&
        !(widget.recitation.canCreateMessage ?? false)) {
      Fluttertoast.showToast(
          msg: translate('you_are_not_allowed_to_create_message'));
    }

    if (user != null &&
        user.id != widget.owner!.id &&
        user.isTeacher &&
        (widget.recitation.canCreateMessage ?? false)) {
      Get.bottomSheet(
        PopupRecitation(
          isLocal: false,
          actions: const [
            PopupActions.addToGeneral,
            PopupActions.delete,
            PopupActions.send,
            PopupActions.createMessge,
          ],
          isOwner: user.id == widget.owner!.id,
          isFinished: widget.dateStr?.isNotEmpty ?? false,
          recitationId: widget.id ?? 0,
          isTeacher: user.isTeacher,
          showInGeneral: true,
          userId: widget.owner!.id,
          recitation: widget.recitation,
        ),
      );
    }
  }
}
