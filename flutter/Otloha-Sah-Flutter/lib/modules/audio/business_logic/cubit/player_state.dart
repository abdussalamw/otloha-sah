part of 'player_cubit.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();

  @override
  List<Object> get props => [];
}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerLoading extends AudioPlayerState {}

class AudioPlayerDownloading extends AudioPlayerState {}

class AudioPlayerReady extends AudioPlayerState {
  final String filePath;

  const AudioPlayerReady(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class AudioPlayerPlaying extends AudioPlayerState {
  final String filePath;

  const AudioPlayerPlaying(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class AudioPlayerStopped extends AudioPlayerState {}

class AudioPlayerError extends AudioPlayerState {
  final String message;

  const AudioPlayerError(this.message);

  @override
  List<Object> get props => [message];
}
