import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/model/translatable.dart';
import '../../../business_logic/recitations/download_chapter_state.dart';
import '../../../business_logic/recitations/download_chapter_cubit.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../../core/widgets/text_view.dart';
import '../settings/narration_page.dart';
import '../settings/recitation_page.dart';
import '../../widgets/item_download.dart';
import '../../../business_logic/chapter/chapter_cubit.dart';
import '../../widgets/search_bar_app.dart';
import '../../widgets/view_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../../data_source/enums/download_types.dart';

class ChapterDownloadPage extends StatefulWidget {
  const ChapterDownloadPage({Key? key}) : super(key: key);
  static const routeName = '/quran/download-center';

  @override
  State<ChapterDownloadPage> createState() => _ChapterDownloadPageState();
}

class _ChapterDownloadPageState extends State<ChapterDownloadPage> {
  int _selected = -1;
  //final List<int> _downloaded = [];

  String? narrationName;
  String? bookName;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChapterCubit>(context).fetchChaptersList();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      narrationName = Translatable.fromJson(json.decode(QuranCacheRepository.narrationSelectedName)).translate();
      bookName = Translatable.fromJson(json.decode(QuranCacheRepository.bookSelectedName)).translate();
    });

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
      title: tr('Download Center'),
      onSearch: (val) {
        BlocProvider.of<ChapterCubit>(context).fetchChaptersList(qurey: val);
        _selected = -1;
      },
    );
  }

  Widget _viewItems() {
    return BlocBuilder<ChapterCubit, ChapterState>(
      builder: (context, state) {
        if (state is ChapterFetched) {
          return _viewData(state.chapters);
        } else if (state is ChapterInitial) {
          return const LoadingWidget();
        } else if (state is ChapterEmpty) {
          return _viewEmpty(state, context);
        } else {
          String error = tr('Not Found Data');

          if (state is ChapterError) {
            error = state.error;
          }

          return ViewError(error: error);
        }
      },
    );
  }

  Widget _viewEmpty(ChapterEmpty state, BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (state.isNarrtion) {
        Navigator.of(context)
            .pushReplacementNamed(NarrationPage.routeName)
            .then((value) {
          BlocProvider.of<ChapterCubit>(context).fetchChaptersList();
        });
      } else {
        Navigator.of(context)
            .pushReplacementNamed(RecitationPage.routeName)
            .then((value) {
          BlocProvider.of<ChapterCubit>(context).fetchChaptersList();
        });
      }
    });
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber,
              color: AppColor.lightBlue,
              size: 150,
            ),
            TextView(
                text:
                    //    'You must Choose ${state.isNarrtion ? 'Narrtation' : 'Reciter'} First'

                    tr('You must Choose') +
                        ((state.isNarrtion)
                            ? tr('Narrtation')
                            : tr('Reciter')) +
                        tr('First')),
          ],
        ),
      ),
    );
  }

  Expanded _viewData(List<Chapter> chapters) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            return BlocProvider<DownloadRecitationChapterCubit>(
                create: (context) => DownloadRecitationChapterCubit(
                    ChapterCubit.get(context).downloadedChapters),
                child: BlocConsumer<DownloadRecitationChapterCubit,
                    DownloadChapterState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return ItemDownload(
                      instance: chapters[index],
                      downloadType: DownloadTypes.chapter,
                      name: chapters[index].name?.translate() ?? '',
                      description: '${narrationName ?? ""} \n${bookName ?? ""}',
                      isDownloaded: DownloadRecitationChapterCubit.get(context)
                          .isDownloaded(chapters[index].id!) ||  state is DownloadCompeleteState,
                      isSelect: _selected == index,
                      onDownload: (ChapterDownload chapterDownload) {
                        ChapterCubit.get(context)
                            .downloadedChapters
                            .add(chapterDownload);

                        DownloadRecitationChapterCubit.get(context)
                            .downloadDone();
                      },
                    );
                  },
                ));
          },
        ),
      ),
    );
  }
}
