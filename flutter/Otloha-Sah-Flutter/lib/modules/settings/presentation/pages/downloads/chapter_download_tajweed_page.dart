import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/model/translatable.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../data_source/models/setting_model/chapter_helper.dart';
import '../../../business_logic/downloads/downloadchapter_cubit.dart';
import '../../../business_logic/downloads/downloads_cubit.dart';
import '../../widgets/chapter_download.dart';
import '../../widgets/search_bar_app.dart';
import '../../widgets/view_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChapterDownloadTajweedPage extends StatefulWidget {
  const ChapterDownloadTajweedPage({Key? key}) : super(key: key);
  static const routeName = '/quran/download-center-tajweed';

  @override
  State<ChapterDownloadTajweedPage> createState() =>
      _ChapterDownloadTajweedPageState();
}

class _ChapterDownloadTajweedPageState
    extends State<ChapterDownloadTajweedPage> {
  late DownloadCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DownloadCubit.get(context);
    _cubit.fetchChaptersList(type: TypeDownload.tajweed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [_topView(context), _viewItems(context)],
        ),
      ),
    );
  }

  _topView(BuildContext context) {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Download Center'),
      onSearch: (val) {
        // BlocProvider.of<ChapterCubit>(context).fetchChaptersList(qurey: val);
        // _selected = -1;
      },
    );
  }

  _viewItems(BuildContext context) {
    return BlocConsumer<DownloadCubit, DownloadTajweedState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is ChapterFetched)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _viewItem(context, index, state.chapters[index]),
                    itemCount: state.chapters.length,
                  ),
                ),
              if (state is DownloadTajweedInitial ||
                  state is DownloadTajweeLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (state is ChapterEmpty || state is ChapterError)
                Center(
                  child: ViewError(error: translate('No Data Found')),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _viewItem(BuildContext context, int index, ChapterHelper chapter) {
    return BlocConsumer<DownloadChapterCubit, DownloadChapterTajwwedState>(
      listener: (context, state) {
        var getIndex = DownloadChapterCubit.get(context).index;
        if (index == getIndex) {
          if (state is DownloadTajweeFinish) {
            _cubit.updateData(chapter..isDownloaded = true, index);
          } else if (state is DownloadTajweeFeild) {
            Fluttertoast.showToast(
                msg: translate('Not Found Data'),
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
          }
        }
      },
      builder: (context, state) {
        var getIndex = DownloadChapterCubit.get(context).index;

        return ChapterDownloadView(
          name: chapter.chapter.name?.translate() ?? '',
          isDownloaded: chapter.isDownloaded,
          description: Translatable.fromJson(json.decode(_cubit.selectedName)).translate(),
          isSelect: false,
          progress: (state is DownloadTajweePrograss && index == getIndex)
              ? state.progress
              : 0,
          startDownload: () {
            BlocProvider.of<DownloadChapterCubit>(context)
                .startDownloadTajweed(chapter.chapter.id ?? 1, index);
          },
          action: () {},
          onLongPress: () {},
        );
      },
    );
  }
}
