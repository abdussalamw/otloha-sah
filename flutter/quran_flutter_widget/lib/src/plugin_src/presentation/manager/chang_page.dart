import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/helper/q.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class QuranController extends ChangeNotifier {
  late QuranCubit cubit;
  int lastPage = CacheHelper.getData(key: Q.lastPageId) ?? 1;

  void setCubit(QuranCubit cubit) {
    this.cubit = cubit;
  }

  changePage(int pageId) {
    cubit.changePage(pageId);
    notifyListeners();
  }

  changeInitPage(int pageNumber) {
    CacheHelper.saveData(key: Q.lastPageNumber, value: pageNumber);
  }

  Future<int> getCurrentPage() async {
    int pageId = CacheHelper.getData(key: Q.lastPageId) ?? 1;
    return pageId;
  }

  changeChapter(Chapter chapter) async {
    await cubit.changeChapter(chapter);
  }

  getCurrentChapterId() {
    return QuranCacheRepository.selectedChapterId ?? 1;
  }

  getCurrentChapterName() {
    return QuranCacheRepository.selectedChapterName ?? '';
  }

  changePageType(PageType pageType) {
    cubit.setPageType(pageType);
  }

  Future<Chapter> getCurrentChapter() async {
    return (await ChapterRepository().fetchChapterById(getCurrentChapterId()))!;
  }
}
