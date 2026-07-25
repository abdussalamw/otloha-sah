import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../data_source/cache_helper.dart';
import '../../../../../core/utils/constant/constants.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../../data_source/models/setting_model/init_data.dart';
import '../../widgets/item_download.dart';
import '../../../business_logic/language/language_cubit.dart';
import '../../widgets/search_bar_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../data_source/enums/download_types.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  static const routeName = '/settings/languages';

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  // ignore: unused_field
  int? _selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [_topView(), _viewItems()],
        ),
      ),
    );
  }

  Widget _topView() {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Languages Center'),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: SettingsMenusData().lang.length,
          itemBuilder: (ctx, index) {
            return _builder(index);
          },
        ),
      ),
    );
  }

  Widget _builder(int index) {
    return ItemDownload(
      // index: index,
      instance: SettingsMenusData().lang[index],
      downloadType: DownloadTypes.page,
      name: SettingsMenusData().lang[index].langName,
      isDownloaded: true,
      isSelect: SettingsMenusData().lang[index].langCode ==
          context.locale.languageCode,
      action: () {
        try {
          Get.dialog(
            const AlertDialogFullScreen(),
            barrierColor: AppColor.backdone,
          );
          CacheHelper.saveData(
              key: Constants.languagesSelectedId, value: index);

          CacheHelper.saveData(
              key: Constants.languagesSelectedName,
              value: SettingsMenusData().lang[index].langName);
          setState(() {
            _selected = index;

            if (index == 0) {
              Constants.isEn = true;
            } else {
              Constants.isEn = false;
            }
          });
          SettingsMenusData().settings[1].subTitle =
              SettingsMenusData().lang[index].langName;
          BlocProvider.of<LanguageCubit>(context)
              .changeLan(Constants.isEn, context);
        } catch (e) {
          printError(info: e.toString());
        }
      },
    );
  }
}
