import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/translatable.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/user_avatar_widget.dart';

import '../../../audio/presentation/wave_view.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../messages/presentation_v2/widgets/message_widget.dart';
import '../../../profile/presentation/page/profile_bnb_page.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';

class RecitationItem extends StatelessWidget {
  const RecitationItem({
    super.key,
    this.isPlay,
    this.isLocal,
    this.toggelPlay,
    this.replay,
    this.recordPath,
    this.wavePath,
    this.userImage,
    this.id,
    this.ownerId,
    this.userName,
    required this.dateStr,
    this.ayah,
    this.ayahInfo,
    this.color,
    this.onPress,
    this.userInfo,
    this.narrationName,
    this.isRead,
    this.isCertic,
    this.hasMenu,
    this.onLongPress,
    this.recitation,
    this.owner,
  });

  final bool? isPlay;
  final bool? isLocal;
  final Function()? toggelPlay;
  final Widget? replay;

  final String? recordPath;
  final String? wavePath;
  final String? userImage;

  final int? id;
  final int? ownerId;
  final User? owner;
  final String? userName;
  final String dateStr;
  final String? ayah;
  final String? ayahInfo;
  final Color? color;
  final Function()? onPress;
  final Function()? onLongPress;

  final String? userInfo;
  final String? narrationName;
  final bool? isRead;
  final bool? isCertic;
  final bool? hasMenu;
  final Recitation? recitation;

  @override
  Widget build(BuildContext context) {
    return MessageWidget(
      onPress: onPress,
      onLongPress: onLongPress,
      userImage: InkWell(
        onTap: () {
          Get.to(
            () => ProfileBNBPage(user: owner),
          );
        },
        child: UserAvatarWidget(
          user: owner,
          imageUrl: owner?.profileImage,
          radius: 24,
        ),
      ),
      userName: _viwName(),
      dataView: _viewData(),
      ayahView: _viewAyah(),
      ayahInfoView: _ayahInfoView(),
      waveView: _waveView(),
      color: AppColor.selectColor1,
      footerView: _footerView(),
    );
  }

  Widget _footerView() {
    if (recitation != null && recitation!.evaluatedAt != null) {
      return Column(
        children: [
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (recitation!.result != null)
                evaluation(
                  recitation!.result! == 'accepted' ? Icons.check : Icons.close,
                  recitation!.result! == 'accepted' ? Colors.green : Colors.red,
                  recitation!.result!,
                ),
              evaluation(Icons.star, Colors.yellow, recitation!.teacherRate!),
              if (recitation!.isRemarkable != null && recitation!.isRemarkable!)
                const Icon(Icons.workspace_premium_outlined)
            ],
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget evaluation(IconData icon, Color color, String text) => Row(
        children: [
          Icon(icon, color: color),
          Text(text),
        ],
      );

  Row _viewData() {
    return Row(
      children: [
        TextView(
          padding: EdgeInsets.zero,
          text: dateStr?.toUpperCase() ?? '',
          sizeText: 10,
          colorText: AppColor.txtColor4,
        ),
      ],
    );
  }

  TextView _viwName() {
    return TextView(
      text: userName ?? tr('Name'),
      weightText: FontWeight.w900,
      padding: EdgeInsets.zero,
      sizeText: 10,
      letterSpacing: 0.4,
      colorText: AppColor.userNameColor,
    );
  }

  _viewAyah() {
    return TextView(
      padding: EdgeInsets.zero,
      text: '$id- $ayah',
      sizeText: 18,
      weightText: FontWeight.w900,
      colorText: AppColor.headTextColor,
      textAlign: TextAlign.start,
      fontFamily: 'Hafs17',
    );
  }

  _ayahInfoView() {
    final narration = Translatable.fromJson(
        jsonDecode(QuranCacheRepository.narrationSelectedName));
    return TextView(
      padding: EdgeInsets.zero,
      text: (ayahInfo ?? '') +
          ' - ${translate('Narrtation')} ' +
          (narrationName ?? narration.translate() ?? ''),
      sizeText: 12,
      colorText: AppColor.userNameColor,
      textAlign: TextAlign.start,
    );
  }

  _waveView() {
    if (recordPath != null && (isLocal ?? false)) {
      return WaveViewPlayAudio(
        isPlay: isPlay ?? false,
        localFilePath: recordPath,
        wavePath: wavePath ?? '',
      );
    }
    if (recitation?.record != null) {
      return WaveViewPlayAudio(
        record: recitation!.record!,
        wavePath: wavePath ?? '',
        toggelPlay: toggelPlay ?? () {},
        isPlay: isPlay ?? false,
      );
    }
    return const SizedBox();
  }
}
