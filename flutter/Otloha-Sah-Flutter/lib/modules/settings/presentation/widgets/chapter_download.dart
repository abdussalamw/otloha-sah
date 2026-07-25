import 'package:flutter/material.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

class ChapterDownloadView extends StatelessWidget {
  const ChapterDownloadView({
    Key? key,
    required this.name,
    this.description,
    required this.isDownloaded,
    required this.isSelect,
    this.onLongPress,
    this.startDownload,
    this.action,
    this.progress,
    this.loopProgress = false,
  }) : super(key: key);

  final String name;
  final String? description;
  final bool isDownloaded;
  final bool isSelect;
  final bool loopProgress;
  final Function()? onLongPress;
  final Function()? action;
  final Function()? startDownload;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: action,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelect ? AppColor.borderColor : AppColor.transparent,
            width: 2,
          ),
          color: isDownloaded ? AppColor.backItem2 : AppColor.backItem,
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
                        text: name,
                        colorText: AppColor.txtColor3,
                        sizeText: 16,
                        weightText: FontWeight.bold,
                        textAlign: TextAlign.start,
                        padding: const EdgeInsets.all(0),
                      ),
                      if (description != null)
                        TextView(
                          text: description ?? '',
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
            isDownloaded ? Container() : _downloadView(),
          ],
        ),
      ),
    );
  }

  Widget _downloadView() {
    return ((progress ?? 0) > 0)
        ? CircularProgressIndicator(
            value: progress,
          )
        : GestureDetector(
            onTap: startDownload,
            child: Image.asset(
              AppIcons.downloadIcon,
              width: 24,
              height: 24,
            ),
          );
  }
}
