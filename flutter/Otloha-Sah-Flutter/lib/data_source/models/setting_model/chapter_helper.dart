import 'package:quran_widget_flutter/model/chapter.dart';

class ChapterHelper {
  Chapter chapter;
  bool isDownloaded;
  bool isSelected;
  ChapterHelper({
    required this.chapter,
    required this.isDownloaded,
    required this.isSelected,
  });

  @override
  String toString() {
    return 'ChapterHelper(chapter: $chapter, isDownloaded: $isDownloaded, isSelected: $isSelected, )';
  }
}
