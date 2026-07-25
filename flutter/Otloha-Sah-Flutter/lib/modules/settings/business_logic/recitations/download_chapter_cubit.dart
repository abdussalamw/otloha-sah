import 'download_chapter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';

class DownloadRecitationChapterCubit extends Cubit<DownloadChapterState> {
  final List<ChapterDownload> downloadedChapters;
  DownloadRecitationChapterCubit(this.downloadedChapters)
      : super(InitialState());

  static DownloadRecitationChapterCubit get(context) =>
      BlocProvider.of<DownloadRecitationChapterCubit>(context);

  bool isDownloaded(int id) =>
      downloadedChapters.where((element) => element.chapterId == id).isNotEmpty;

  downloadDone() => emit(DownloadCompeleteState());
}
