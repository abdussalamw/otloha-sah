import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/exception_indicators/error_indicator.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../../data_source/enums/download_types.dart';
import '../../../business_logic/quraan_translation_cubit/quran_translation_state.dart';
import '../../widgets/item_download.dart';

import '../../../business_logic/quraan_translation_cubit/quran_translation_cubit.dart';
import '../../widgets/search_bar_app.dart';

class QuranTranslationLanguagePage extends StatefulWidget {
  const QuranTranslationLanguagePage({Key? key}) : super(key: key);

  static const routeName = '/settings/quranTranslationLanguage';

  @override
  _QuranTranslationLanguagePageState createState() =>
      _QuranTranslationLanguagePageState();
}

class _QuranTranslationLanguagePageState
    extends State<QuranTranslationLanguagePage> {
  @override
  void initState() {
    super.initState();
    QuranTranslationCubit.get(context).fetchTranslationList();
  }

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
      title: tr('Quran Translation Language Center'),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: BlocBuilder<QuranTranslationCubit, QuranTranslationState>(
        builder: (context, state) {
          if (state is QuranTranslationFetched) {
            return _viewData(state);
          }
          if (state is QuranTranslationError) {
            return Center(child: ErrorIndicator(error: state.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Padding _viewData(QuranTranslationFetched state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: state.translations.length,
        itemBuilder: (context, index) {
          return ItemDownload(
            instance: null,
            downloadType: DownloadTypes.page,
            name: state.translations[index].name!.translate() ?? '',
            description: state.translations[index].author?.translate() ?? '',
            isDownloaded: true,
            isSelect: QuranTranslationCubit.get(context)
                .isSelectd(state.translations[index].id ?? 1),
            action: () {
              Get.dialog(
                const AlertDialogFullScreen(),
                barrierColor: AppColor.backdone,
              );
              QuranTranslationCubit.get(context).setTranslation(
                state.translations[index].id ?? 1,
                name: state.translations[index].name?.translate() ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
