import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/exception_indicators/error_indicator.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../business_logic/tajweed/tajweed_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../widgets/item_download.dart';
import '../../widgets/search_bar_app.dart';
import 'package:get/get.dart';

import '../../../../../data_source/enums/download_types.dart';

class TajweedPage extends StatefulWidget {
  const TajweedPage({Key? key}) : super(key: key);
  static const routeName = '/settings/tajweed';

  @override
  State<TajweedPage> createState() => _TajweedPageState();
}

class _TajweedPageState extends State<TajweedPage> {
  TajweedCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = TajweedCubit.get(context);
    cubit!.fetchTajweedList();
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
      title: translate('Tajweed'),
    );
  }

  _viewItems() {
    return Expanded(
      child: BlocConsumer<TajweedCubit, TajweedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TajweedFetched) {
            return _viewData(state);
          }
          if (state is TajweedError) {
            return Center(child: ErrorIndicator(error: state.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Padding _viewData(TajweedFetched state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: state.tajweed.length,
        itemBuilder: (context, index) {
          return ItemDownload(
            instance: Null,
            downloadType: DownloadTypes.page,
            name: state.tajweed[index].name?.translate() ?? '',
            description: state.tajweed[index].author?.translate(),
            isDownloaded: true,
            isSelect: cubit!.tajweedId == state.tajweed[index].id,
            action: () {
              Get.dialog(
                const AlertDialogFullScreen(),
                barrierColor: AppColor.backdone,
              );
              cubit!.setTajweed(state.tajweed[index].id ?? 1,
                  name: state.tajweed[index].name);
            },
          );
        },
      ),
    );
  }
}
