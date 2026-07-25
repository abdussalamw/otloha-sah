import '../../../../data_source/models/setting_model/chapter_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'downloads_state.dart';

enum TypeDownload {
  tajweed,
  tafseer,
  targama,
}

class DownloadCubit extends Cubit<DownloadTajweedState> {
  DownloadCubit() : super(DownloadTajweedInitial());

  static DownloadCubit get(context) => BlocProvider.of<DownloadCubit>(context);

  String selectedName = '';
  double progress = 0;
  List<ChapterHelper> chapters = [];

  fetchChaptersList({
    String? qurey,
    bool isSelect = false,
    required TypeDownload type,
  }) async {
    emit(DownloadTajweeLoading());
    try {
      int narrationId = QuranCacheRepository.narrationSelectedId;
      List<Chapter> fetchedChapters = await DataSource.instance
              .fetchChaptersList(qurey: qurey, narrationId: narrationId) ??
          [];

      if (fetchedChapters.isNotEmpty) {
        chapters.clear();
        List downlodedChapters = await getSavedChapters(type) ?? [];
        List<int> chaptersIds = downlodedChapters
            .expand<int>((element) => [element.chapter])
            .toList();
        for (var chapter in fetchedChapters) {
          chapters.add(
            ChapterHelper(
              chapter: chapter,
              isDownloaded: chaptersIds.contains(chapter.id),
              isSelected: false,
            ),
          );
        }
        emit(ChapterFetched(chapters));
      } else {
        emit(ChapterEmpty());
      }
    } catch (e) {
      emit(ChapterError(e.toString()));
      print('Error: $e');
    }
  }

  void updateData(ChapterHelper chapterHelper, int index) {
    chapters[index] = chapterHelper;
    emit(ChapterFetched(chapters));
  }

  Future<List<dynamic>?> getSavedChapters(TypeDownload type) async {
    if (type == TypeDownload.tajweed) {
      selectedName = QuranCacheRepository.selectedTajweedName;
      int? tajweedId = QuranCacheRepository.selectedTajweedId;
      return await DataSource.instance
          .getSavedTajweedChapters(bookId: tajweedId ?? 1);
    }
    if (type == TypeDownload.tafseer) {
      selectedName = QuranCacheRepository.tafsirSelectedName;
      int? tafseerId = QuranCacheRepository.tafsirSelectedId;
      return await DataSource.instance
          .getSavedExplainationChaptersByBookId(tafseetId: tafseerId ?? 1);
    }
    if (type == TypeDownload.targama) {
      selectedName = QuranCacheRepository.quranTranslationSelectedName;
      int? targamaId = QuranCacheRepository.quranTranslationSelectedId;
      return await DataSource.instance
          .getTranslationsSavedChapters(tranId: targamaId ?? 1);
    }
    return Future.value(null);
  }
}
