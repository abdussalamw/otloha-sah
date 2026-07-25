import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../data_source/enums/download_types.dart';

class ItemDownload extends StatefulWidget {
  const ItemDownload({
    Key? key,
    required this.name,
    this.description,
    required this.isDownloaded,
    required this.isSelect,
    this.onLongPress,
    this.onDownload,
    this.action,
    required this.downloadType,
    required this.instance,
  }) : super(key: key);

  final String name;
  final String? description;
  final bool isDownloaded;
  final bool isSelect;
  final Function()? onLongPress;
  final Function(ChapterDownload)? onDownload;
  final Function()? action;
  final DownloadTypes downloadType;
  final dynamic instance;

  @override
  State<ItemDownload> createState() => _ItemDownloadState();
}

class _ItemDownloadState extends State<ItemDownload> {
  double _progress = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.action,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                widget.isSelect ? AppColor.borderColor : AppColor.transparent,
            width: 2,
          ),
          color: widget.isDownloaded ? AppColor.backItem2 : AppColor.backItem,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.iconListIcon,
                  width: 40,
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextView(
                        text: widget.name,
                        colorText: AppColor.txtColor3,
                        sizeText: 16,
                        weightText: FontWeight.bold,
                        textAlign: TextAlign.start,
                        padding: const EdgeInsets.all(0),
                      ),
                      if (widget.description != null)
                        TextView(
                          text: widget.description ?? '',
                          colorText: AppColor.txtColor4,
                          sizeText: 12,
                          padding: const EdgeInsets.all(0),
                          textAlign: TextAlign.start,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            widget.isDownloaded ? Container() : _downloadView(),
          ],
        ),
      ),
    );
  }

  Widget _downloadView() {
    return (_progress >= 0)
        ? CircularProgressIndicator(
            value: _progress,
          )
        : GestureDetector(
            onTap: _startDownload,
            child: Image.asset(
              AppIcons.downloadIcon,
              width: 24,
              height: 24,
            ),
          );
  }

  void _startDownload() {
    if (DownloadTypes.chapter == widget.downloadType) {
      setState(() {
        _progress = 0;
      });
      DataSource.instance
          .downloadChapter(
        chapterId: widget.instance.id,
        recitationId: QuranCacheRepository.selectedRecitationId ?? 1,
        reciterId: QuranCacheRepository.selectedReciterId ?? 1,
        narrationId: QuranCacheRepository.narrationSelectedId ?? 1,
        retunProgress: (val) {
          setState(() {
            _progress = val;
          });
        },
      )
          .then((value) {
        widget.onDownload!(value);
      });
    }
  }
}
