import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../widgets/change_narration.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../business_logic/narration/narration_cubit.dart';
import '../../widgets/item_download.dart';
import '../../widgets/search_bar_app.dart';
import '../../widgets/view_error.dart';

import '../../../../../data_source/enums/download_types.dart';

class NarrationPage extends StatefulWidget {
  const NarrationPage({super.key});

  static const routeName = '/settings/narration';

  @override
  State<NarrationPage> createState() => _NarrationPageState();
}

class _NarrationPageState extends State<NarrationPage> {
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NarrationCubit>(context).fetchNarration();
  }

  @override
  Widget build(BuildContext context) {
    try {
      _selected = QuranCacheRepository.narrationSelectedId;
    } catch (e) {
      debugPrint(e.toString());
    }
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
      title: tr('Narrations Center'),
      onSearch: (val) {
        BlocProvider.of<NarrationCubit>(context).fetchNarration(qurey: val);
      },
    );
  }

  Widget _viewItems() {
    return BlocBuilder<NarrationCubit, NarrationState>(
      builder: (context, state) {
        if (state is NarrationFetched) {
          _selected = state.selected;
          return _viewData(state.narrations);
        }
        if (state is NarrationChangeSelected) {
          _selected = state.selected;
          return _viewData(state.narrations);
        } else if (state is NarrationInitial) {
          return const LoadingWidget();
        } else {
          String error = 'Not Found Data';

          if (state is NarrationError) {
            error = state.error;
          }

          return ViewError(error: error);
        }
      },
    );
  }

  Expanded _viewData(List<Narration>? narrations, {bool isDemo = false}) {
    print(_selected);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: isDemo ? 15 : narrations!.length,
          itemBuilder: (context, index) {
            return ItemDownload(
              instance: narrations![index],
              downloadType: DownloadTypes.page,
              name: isDemo
                  ? tr('narrations name')
                  : narrations[index].name.translate().toString(),
              description: isDemo
                  ? tr('narrations description')
                  : narrations[index].description.translate().toString(),
              isDownloaded: true,
              isSelect: _selected == index,
              action: () async {
                Get.dialog(
                  ChangeNarrtionPopup(
                    narration: narrations[index],
                  ),
                  // barrierColor: AppColor.backdone,
                ).then((value) {
                  Get.dialog(
                    const AlertDialogFullScreen(),
                    barrierColor: AppColor.backdone,
                  );
                });
                BlocProvider.of<NarrationCubit>(context).changeSelected(index);
              },
            );
          },
        ),
      ),
    );
  }
}
