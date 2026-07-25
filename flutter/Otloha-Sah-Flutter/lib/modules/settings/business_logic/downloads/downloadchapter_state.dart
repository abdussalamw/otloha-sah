part of 'downloadchapter_cubit.dart';

abstract class DownloadChapterTajwwedState {
  const DownloadChapterTajwwedState();
}

class DownloadChapterTajwwedInitial extends DownloadChapterTajwwedState {}

class DownloadTajweeStart extends DownloadChapterTajwwedState {}

class DownloadTajweePrograss extends DownloadChapterTajwwedState {
  final double progress;

  DownloadTajweePrograss({required this.progress});
}

class DownloadTajweeFinish extends DownloadChapterTajwwedState {}

class DownloadTajweeFeild extends DownloadChapterTajwwedState {}
