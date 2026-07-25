part of 'chapter_cubit.dart';

abstract class ChapterState {
  const ChapterState();
}

class ChapterInitial extends ChapterState {}

class ChapterFetched extends ChapterState {
  final List<Chapter> chapters;
  const ChapterFetched(this.chapters);
}

class ChapterError extends ChapterState {
  final String error;
  const ChapterError(this.error);
}

class ChapterEmpty extends ChapterState {
  final bool isNarrtion;
  const ChapterEmpty(this.isNarrtion);
}
