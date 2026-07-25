part of 'downloads_cubit.dart';

abstract class DownloadTajweedState {
  const DownloadTajweedState();
}

class DownloadTajweedInitial extends DownloadTajweedState {}

class ChapterFetched extends DownloadTajweedState {
  final List<ChapterHelper> chapters;
  const ChapterFetched(this.chapters);
}

class ChapterError extends DownloadTajweedState {
  final String error;
  const ChapterError(this.error);
}

class ChapterEmpty extends DownloadTajweedState {}

class DownloadTajweeLoading extends DownloadTajweedState {}
