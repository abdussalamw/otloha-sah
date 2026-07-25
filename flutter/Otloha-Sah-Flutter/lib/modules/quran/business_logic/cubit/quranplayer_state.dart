part of 'quranplayer_cubit.dart';

abstract class QuranPlayerState extends Equatable {
  const QuranPlayerState();
}

class QuranPlayerInitial extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class BackToPreviousVerse extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class GoToNextVerse extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class PauseVersesState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class PlayVersesState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class PlayerStateChange extends QuranPlayerState {
  final String state;

  const PlayerStateChange(this.state);
  @override
  List<Object?> get props => [state];
}

class PLayerIndexChanged extends QuranPlayerState {
  final int index;
  const PLayerIndexChanged({required this.index});
  @override
  List<Object?> get props => [index];
}

class PlayerChanged extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class InitialLoadingPlayerState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class FinishLoadingPlayerState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class PlayerRepeatModeChange extends QuranPlayerState {
  final AudioServiceRepeatMode repeatMode;
  const PlayerRepeatModeChange({
    required this.repeatMode,
  });
  @override
  List<Object?> get props => [repeatMode];
}

class DownloadingChapterState extends QuranPlayerState {
  final double progress;
  const DownloadingChapterState({
    required this.progress,
  });
  @override
  List<Object?> get props => [progress];
}

class DownloadingCompeleteState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}

class DownloadingChapterErrorState extends QuranPlayerState {
  @override
  List<Object?> get props => [];
}
