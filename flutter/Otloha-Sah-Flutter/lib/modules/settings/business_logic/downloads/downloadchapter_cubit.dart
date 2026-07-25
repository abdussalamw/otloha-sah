import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'downloadchapter_state.dart';

class DownloadChapterCubit extends Cubit<DownloadChapterTajwwedState> {
  DownloadChapterCubit() : super(DownloadChapterTajwwedInitial());

  static DownloadChapterCubit get(context) =>
      BlocProvider.of<DownloadChapterCubit>(context);
  int index = 0;

  void startDownloadTajweed(int chapterId, int index) async {
    emit(DownloadTajweeStart());

    this.index = index;

    int? tajweedId = QuranCacheRepository.selectedTajweedId;

    List<TajweedCharacters>? data =
        await DataSource.instance.fetchTajweedCharactersByChapterList(
            bookId: tajweedId ?? 1,
            chapterId: chapterId,
            onDownloadProgress: (recieved, total) {
              emit(DownloadTajweePrograss(progress: recieved / total));
            });

    if (data != null && data.isNotEmpty) {
      emit(DownloadTajweeFinish());
    } else {
      emit(DownloadTajweeFeild());
    }
  }

  void startDownloadTafseer(int chapterId, int index) async {
    emit(DownloadTajweeStart());

    this.index = index;

    int? tafseetId = QuranCacheRepository.tafsirSelectedId;

    List<ExplanationVerse>? data =
        await DataSource.instance.fetchTafseerVersesList(
            tafseetId: tafseetId ?? 1,
            chapter: chapterId,
            onDownloadProgress: (recieved, total) {
              emit(DownloadTajweePrograss(progress: recieved / total));
            });

    if (data != null && data.isNotEmpty) {
      emit(DownloadTajweeFinish());
    } else {
      emit(DownloadTajweeFeild());
    }
  }

  void startDownloadTargama(int chapterId, int index) async {
    emit(DownloadTajweeStart());

    this.index = index;

    int? tafseetId = QuranCacheRepository.quranTranslationSelectedId;

    List<TranslationVerse>? data =
        await DataSource.instance.fetchTranslationVerseList(
            tranId: tafseetId ?? 1,
            chapter: chapterId,
            onDownloadProgress: (recieved, total) {
              emit(DownloadTajweePrograss(progress: recieved / total));
            });

    if (data != null && data.isNotEmpty) {
      emit(DownloadTajweeFinish());
    } else {
      emit(DownloadTajweeFeild());
    }
  }
}
