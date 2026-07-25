import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation_quran_meta_data.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/themes/color.dart';

enum RecitationMetaTitleOptions {
  chapter,
  verses,
  narration,
}

class RecitationMetaTitle extends StatelessWidget {
  const RecitationMetaTitle(
      {Key? key, required this.recitation, required this.options});

  final Recitation recitation;
  final List<RecitationMetaTitleOptions> options;

  getTitle(RecitationQuranMetaData metaData) {
    List<String> title = [];
    if (options.contains(RecitationMetaTitleOptions.narration)) {
      return metaData.narration!.name.translate();
    }
    if (options.contains(RecitationMetaTitleOptions.chapter)) {
      if (metaData.chapter != null) {
        title.add(metaData.chapter!.name!.translate() ?? '');
      }
    }
    if (options.contains(RecitationMetaTitleOptions.verses)) {
      if (metaData.verses!.length > 1) {
        title.add(
            '${tr('from')} ${metaData.verses!.first.verseNumber} ${tr('to')} ${metaData.verses!.last.verseNumber}');
      } else {
        title.add(metaData.verses!.first.verseNumber.toString());
      }
    }
    return title.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecitationQuranMetaData>(
      future: recitation.getQuranMetaData(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? AutoSizeText(
                getTitle(snapshot.data!),
                style: TextStyle(
                  color: AppColor.userNameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                  fontFamily: Constants.fontFamily3,
                ),
                textAlign: TextAlign.start,
              )
            : const SizedBox();
      },
    );
  }
}
