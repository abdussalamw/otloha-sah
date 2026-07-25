import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
part 'chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  Recitation? recitation;
  List<ChapterDownload> downloadedChapters = [];

  ChapterCubit() : super(ChapterInitial());

  static ChapterCubit get(context) => BlocProvider.of<ChapterCubit>(context);

  fetchDownloadedChapters() async {
    downloadedChapters =
        await ChapterDownloadLocalDataSource().fetchChapterDownloadsList() ??
            [];
  }

  fetchChaptersList({String? qurey, bool isSelect = false}) async {
    try {
      fetchDownloadedChapters();
      int narrationId = QuranCacheRepository.narrationSelectedId;
      int reciterId = QuranCacheRepository.selectedReciterId;

      DataSource.instance
          .fetchChaptersList(qurey: qurey, narrationId: narrationId)
          .then(
        (value) async {
          if (value!.isNotEmpty) {
            if (isSelect) {
              emit(ChapterFetched(value));
              return;
            }
            // ignore: unnecessary_null_comparison
            if ((narrationId != null && reciterId != null)) {
              DataSource.instance
                  .fetchRecitationsList(narrationId: narrationId)
                  .then((recitations) {
                if (recitations != null && recitations.isNotEmpty) {
                  recitation = recitations.firstWhere(
                      (element) => (element.narrationId == narrationId &&
                          element.reciterId == reciterId),
                      orElse: () =>
                          Recitation(0, narrationId, reciterId, null));
                  if (recitation != null) {
                    //  emit(ChapterInitial());
                  } else {
                    emit(const ChapterError('Not Found Data'));
                  }
                  (element) => (element._narrationId == narrationId &&
                      element.reciterId == reciterId);
                }
                if (recitation != null || (recitation?.id ?? 0) == 0) {
                  emit(ChapterFetched(value));
                } else {
                  emit(const ChapterError('Not Found Data'));
                }
              });

              emit(ChapterFetched(value));
            } else {
              emit(const ChapterError('Not Found Data'));
            }
          } else {
            emit(ChapterEmpty(narrationId == 0));
          }
        },
      );
    } catch (e) {
      emit(ChapterError(e.toString()));
    }
  }
}
