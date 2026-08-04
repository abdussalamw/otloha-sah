import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/helper/q.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/audio/service/audio_service.dart';

class PlayerController {
  final dynamic onPlay;
  final dynamic onPause;
  final dynamic onSetRepeatMode;
  final dynamic onNext;
  final dynamic onPrev;
  final dynamic onStop;

  PlayerController({
    this.onPlay,
    this.onPause,
    this.onSetRepeatMode,
    this.onNext,
    this.onPrev,
    this.onStop,
  });

  Future<void> initVerses({dynamic onDownload, dynamic onCompelete, dynamic onPlayStateChanged}) async {}
  Future<void> next() async {}
  Future<void> previous() async {}
  Future<void> play() async {}
  Future<void> pause() async {}
  Future<void> stop() async {}
  Future<AudioServiceRepeatMode> changeRepeateMode() async { return AudioServiceRepeatMode.none; }
}

class QuranController extends ChangeNotifier {
  late QuranCubit cubit;
  int lastPage = CacheHelper.getData(key: Q.lastPageId) ?? 1;
  PlayerController playerController = PlayerController();

  QuranController({PlayerController? playerController}) {
    if (playerController != null) {
      this.playerController = playerController;
    }
  }

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
