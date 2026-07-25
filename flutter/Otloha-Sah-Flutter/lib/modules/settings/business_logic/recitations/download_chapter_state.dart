abstract class DownloadChapterState {}

class InitialState extends DownloadChapterState {}

class DownloadInPregressState extends DownloadChapterState {
  double progress;
  DownloadInPregressState({required this.progress});
}

class DownloadPauseState extends DownloadChapterState {}

class DownloadCompeleteState extends DownloadChapterState {}

class DownloadErrorState extends DownloadChapterState {}
