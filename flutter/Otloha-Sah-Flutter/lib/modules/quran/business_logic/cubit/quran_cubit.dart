import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';
import 'package:quran_widget_flutter/model/chapter.dart' as chapter;
import 'package:quran_widget_flutter/model/translatable.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/user_services_data.dart';

part 'quran_state.dart';

class QuranViewCubit extends Cubit<QuranViewState> {
  QuranViewCubit() : super(QuranViewInitial()) {
    init();
  }

  void init() {
    chapterId = QuranCacheRepository.selectedChapterId ?? 1;
    bookId = QuranCacheRepository.bookSelectedId ?? 1;
    narrationId = QuranCacheRepository.narrationSelectedId ?? 1;
    chapterName = Translatable.fromJson(
                json.decode(QuranCacheRepository.selectedChapterName))
            .translate() ??
        '';
    getIsATeacher();
  }

  bool isDisable = false;
  bool hasFavTeacher = false;

  getIsATeacher() async {
    isATeacher =
        (await UserDataServices.instance.getUserData())?.isTeacher ?? false;
    var teacher = await UserDataServices.instance.getFavTeacherData();
    if (teacher != null) {
      hasFavTeacher = true;
    } else {
      hasFavTeacher = false;
    }
  }

  static QuranViewCubit get(context) =>
      BlocProvider.of<QuranViewCubit>(context);

  late QuranController _controller;

  setQuranController(QuranController controller) {
    _controller = controller;
  }

  QuranController get controller => _controller;

  List<Verse> selectedVerses = [];
  bool checkVersesValue = false;
  bool isATeacher = false;

  setSelectedVerses(List<Verse> verses) {
    selectedVerses = verses;
    if (selectedVerses.isEmpty) {
      checkVersesValue = false;
      emit(CheckIsVerseEmptyState());

      return false;
    } else {
      checkVersesValue = true;

      emit(CheckIsVerseEmptyState());
    }
  }

  List<Verse> get getSelectedVerses => selectedVerses;

  isVerSelected(bool? verses) {
    if (verses == null || verses == false || selectedVerses.isEmpty) {
      checkVersesValue = false;
      emit(CheckIsVerseEmptyState());

      return false;
    } else {
      checkVersesValue = true;

      emit(CheckIsVerseEmptyState());
    }

    emit(DoneCheckIsVerseEmptyState());
  }

  PageType pageType = PageType.quran;

  Future<void> changePluginPageType({required PageType page}) async {
    pageType = page;
  }

  Future<void> changePageType({required PageType page}) async {
    pageType = page;
    controller.changePageType(page);
    emit(ChangePageState());
  }

  late int chapterId = controller.getCurrentChapterId();
  late int bookId;
  late int narrationId;
  late String chapterName;

  chapter.Chapter? currentChapter;

  updateChapterHeaderInfo(Chapter chapter) async {
    chapterName = chapter.name!.translate() ?? '';
    chapterId = chapter.id!;
    currentChapter = chapter;
    emit(ChangeChapterState());
  }

  bool isLiked = false;
  bool isBookmarked = false;
  bool isOnPressed = false;
  bool isRecorded = false;
  bool isRecordedFile = false;
  bool isSelectedVerse = false;
  bool isPlaying = false;
  bool playPause = false;

  int lastPlayedVerseNumber = 1;
  bool isRecitationVersesFetched = false;
  bool isPlayerStarted = false;
  bool isVerseCompleted = true;
  List<RecitationVerses>? recitationVerses = [];

  FavoriteVerse? like;
  FavoritePage? mark;
  getIsMarkorlike() async {
    if (isPlaying) {
      isPlaying = false;
    }

    int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;
    like = await DatabaseRepository.favoriteVersesDao!
        .findById(QuranCacheRepository.lastPageNumber ?? 1, uid);
    mark = await DatabaseRepository.favoritePagesDao!
        .findById(QuranCacheRepository.lastPageNumber ?? 1, uid);
    if (like != null) {
      isLiked = true;
    } else {
      isLiked = false;
    }

    if (mark != null) {
      isBookmarked = true;
    } else {
      isBookmarked = false;
    }

    emit(ChangeBookMarkState());
  }

  changeIsPlaying() {
    isOnPressed = false;
    isSelectedVerse = false;
    isRecorded = false;
    isRecordedFile = false;
    isPlaying = true;
    emit(ChangeIsPlayingState());
  }

  changeIsSelectedVerse() {
    isSelectedVerse = true;

    emit(ChangeIsSelectedVerseState());
  }

  changeTrueFloating() {
    isOnPressed = false;
    isRecorded = false;
    isRecordedFile = false;

    emit(IsFloatTrueMenuState());
  }

  changeFalseFloating() {
    isOnPressed = false;
    emit(IsFloatingFalseMenuState());
  }

  changeIsLiked() {
    if (isLiked == false) {
      isLiked = true;
      emit(ChangeLikedState());
    } else {
      isLiked = false;
      emit(ChangeLikedState());
    }
  }

  changeIsBookmarked() {
    if (isBookmarked == false) {
      isBookmarked = true;
      emit(ChangeBookMarkState());
    } else {
      isBookmarked = false;
      emit(ChangeBookMarkState());
    }
  }

  changeIsOnTruePressed() {
    isOnPressed = true;
    isSelectedVerse = false;
    isPlaying = false;
    isRecorded = false;
    // isRecordedFile = false;
    checkVersesValue = true;

    emit(IsOnPressFalseState());
  }

  changeIsOnFalsePressed() {
    isOnPressed = false;
    isPlaying = false;
    isRecordedFile = false;
    emit(IsOnPressTrueState());
  }

  changeIsRecorded() {
    isOnPressed = false;
    isSelectedVerse = false;
    isRecordedFile = false;
    isRecorded = true;
    emit(IsRecordedState());
  }

  changeIsRecordedFile() {
    isOnPressed = false;
    isSelectedVerse = false;

    isRecorded = false;
    isRecordedFile = true;
    emit(IsRecordedFileState());
  }

  int recitationId = 0;

  String getFirstWords(String sentence, int wordCounts) {
    try {
      return sentence.split(' ').sublist(0, wordCounts).join(' ');
    } catch (e) {
      return sentence;
    }
  }

  saveLiked({bool? isSelect}) async {
    isDisable = true;
    emit(IsDisableState());
    changeIsLiked();
    List<Verse> verses = await DataSource.instance
        .fetchVersesByPageNumber(QuranCacheRepository.lastPageNumber ?? 1);

    int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;

    if (isSelect == true) {
      //   like = await DatabaseRepository.instance.insertVerseLiked(
      //     VerseLiked(
      //       idFromVerse: selectedVerses.first.id,
      //       pageNumber: QuranCacheRepository.lastPageNumber ?? 1,
      //       textFristVerse: getFirstWords(selectedVerses.first.text ?? '', 5),
      //       idToVerse: selectedVerses.last.id,
      //       userId: uid,
      //     ),
      //   );
      // } else {
      //   like = await DatabaseRepository.instance.insertVerseLiked(
      //     VerseLiked(
      //       idFromVerse: verses.first.id,
      //       pageNumber: QuranCacheRepository.lastPageNumber ?? 1,
      //       textFristVerse: getFirstWords(verses.first.text ?? '', 5),
      //       idToVerse: verses.last.id,
      //       userId: uid,
      //     ),
      //   );
    }

    isDisable = false;
    emit(IsDisableState());
  }

  deleteLike() async {
    isDisable = true;
    emit(IsDisableState());
    changeIsLiked();
    await DatabaseRepository.instance.deleteVerseLiked(like!.id ?? 0);
    isDisable = false;
    emit(IsDisableState());
  }

  addBookMark() async {
    isDisable = true;
    emit(IsDisableState());
    List<Verse> verses = await DataSource.instance
        .fetchVersesByPageNumber(QuranCacheRepository.lastPageNumber ?? 1);

    int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;

    // await DatabaseRepository.instance.insertPageMarked(
    //   // PageMarked(
    //   //   pageNumber: QuranCacheRepository.lastPageNumber ?? 1,
    //   //   textVerse: getFirstWords(verses.first.text ?? '', 5),
    //   //   userId: uid,
    //   //   idBook: verses.first.bookId,
    //   //   idPage: verses.first.pageNumber,
    //   // ),
    // );
    isDisable = false;
    changeIsBookmarked();
  }

  deleteBookMark() async {
    isDisable = true;
    emit(IsDisableState());
    await DatabaseRepository.instance.deletePageMarked(mark?.id ?? 0);
    isBookmarked = false;

    isDisable = false;
    emit(ChangeBookMarkState());
  }

  void hideToolBar() {
    checkVersesValue = false;
    emit(CheckIsVerseEmptyState());
  }

  void changeChapter() {
    emit(ChangeChapterState());
  }

  bool get checkOpened {
    var b = checkVersesValue ||
        isPlaying ||
        isRecorded ||
        isRecordedFile ||
        selectedVerses.isNotEmpty;

    return b;
  }

  void showLoader() {
    emit(ShowLoaderState());
  }

  void dispose() {
    checkVersesValue = false;
    isPlaying = false;
    isRecorded = false;
    isRecordedFile = false;
    isOnPressed = false;
    selectedVerses.clear();
  }
}
