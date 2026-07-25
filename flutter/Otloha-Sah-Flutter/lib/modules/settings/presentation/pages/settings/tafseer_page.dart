import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/exception_indicators/error_indicator.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../../data_source/enums/download_types.dart';
import '../../../business_logic/tafseer_cubit/tafsir_cubit.dart';
import '../../widgets/item_download.dart';
import '../../widgets/search_bar_app.dart';

class TafseerPage extends StatefulWidget {
  const TafseerPage({Key? key}) : super(key: key);

  static const routeName = '/settings/tafseer';

  @override
  State<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends State<TafseerPage> {
  TafsirCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = TafsirCubit.get(context);
    cubit!.fetchTafsirList();
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
      onSearch: (val) {
        cubit!.fetchTafsirList(qurey: val);
      },
      title: tr('Tafseer'),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: BlocConsumer<TafsirCubit, TafsirState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TafsirFetched) {
            return _viewData(state);
          }

          if (state is TafsirError) {
            return Center(child: ErrorIndicator(error: state.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Padding _viewData(TafsirFetched state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: state.tafsir.length,
        itemBuilder: (context, index) {
          return ItemDownload(
            instance: null,
            downloadType: DownloadTypes.page,
            name: state.tafsir[index].name?.translate() ?? '',
            isDownloaded: true,
            isSelect: (cubit?.tafsirId ?? 0) == state.tafsir[index].id,
            action: () {
              Get.dialog(
                const AlertDialogFullScreen(),
                barrierColor: AppColor.backdone,
              );
              cubit!.setTafseer(state.tafsir[index].id ?? 1,
                  name: state.tafsir[index].name?.translate());
            },
          );
        },
      ),
    );
  }
}
