import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/exception_indicators/error_indicator.dart';
import '../../../business_logic/recitations/recitations_cubit.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../../core/widgets/loading.dart';
import '../../widgets/item_download.dart';
import '../../widgets/search_bar_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../../data_source/enums/download_types.dart';

class RecitationPage extends StatefulWidget {
  const RecitationPage({Key? key}) : super(key: key);

  static const routeName = '/settings/recitations';
  @override
  _RecitationPageState createState() => _RecitationPageState();
}

class _RecitationPageState extends State<RecitationPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RecitationsCubit>(context).fetchRecitations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topView(),
            _viewItems(),
          ],
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
      title: tr('Recitations'),
    );
  }

  Widget _viewItems() {
    return BlocBuilder<RecitationsCubit, RecitationsState>(
      builder: (context, state) {
        if (state is RecitationsFetched) {
          return _viewData(state.recitations, state.selected);
        }

        if (state is RecitationsErrorState) {
          return Expanded(child: ErrorIndicator(error: state.error));
        }
        return const LoadingWidget();
      },
    );
  }

  Widget _viewData(List<Recitation>? recitations, int selected) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: recitations!.length,
          itemBuilder: (context, index) {
            return ItemDownload(
              instance: null,
              downloadType: DownloadTypes.page,
              description: recitations[index].reciter!.name?.translate() ?? '',
              name: recitations[index].name?.translate() ?? '',
              isDownloaded: true,
              isSelect: selected == recitations[index].id!,
              action: () {
                Get.dialog(
                  const AlertDialogFullScreen(),
                  barrierColor: AppColor.backdone,
                );
                BlocProvider.of<RecitationsCubit>(context).setRecitation(
                    recitations[index].id!,
                    name: recitations[index].reciter!.name?.translate() ?? '');
              },
            );
          },
        ),
      ),
    );
  }
}
