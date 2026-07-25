part of 'quran_cubit.dart';

abstract class QuranViewState {
  const QuranViewState();
}

class QuranViewInitial extends QuranViewState {}

class ChangeLikedState extends QuranViewState {}

class IsOnPressFalseState extends QuranViewState {}

class IsOnPressTrueState extends QuranViewState {}

class ChangeBookMarkState extends QuranViewState {}

class IsRecordedState extends QuranViewState {}

class IsRecordedFileState extends QuranViewState {}

class GetDurationState extends QuranViewState {}

class ChangeDurationState extends QuranViewState {}

class GetChapterByIdLoadingState extends QuranViewState {}

class GetChapterByIdSucssState extends QuranViewState {}

class GetChapterByIdErrorState extends QuranViewState {}

class IsFloatingFalseMenuState extends QuranViewState {}

class ChangeOpacityState extends QuranViewState {}

class ChangeIsSelectedVerseState extends QuranViewState {}

class IsFloatTrueMenuState extends QuranViewState {}

class ChangeIsPlayingState extends QuranViewState {}

class PlayVersesState extends QuranViewState {}

class PauseVersesState extends QuranViewState {}

class BackToPreviousVerse extends QuranViewState {}

class GoToNextVerse extends QuranViewState {}

class ChangePageState extends QuranViewState {}

class QuranChangeChapter extends QuranViewState {}

class CheckIsVerseEmptyState extends QuranViewState {}

class DoneCheckIsVerseEmptyState extends QuranViewState {}

class ChangeChapterState extends QuranViewState {}

class IsDisableState extends QuranViewState {}

class ShowLoaderState extends QuranViewState {}

class RecordHasPermission extends QuranViewState {
  final bool hasPermission;
  const RecordHasPermission({
    required this.hasPermission,
  });
}

class RecordIsPlay extends QuranViewState {
  final bool isPlay;
  const RecordIsPlay({
    required this.isPlay,
  });
}

class RecordIsRecord extends QuranViewState {
  final bool isRecord;
  const RecordIsRecord({
    required this.isRecord,
  });
}
