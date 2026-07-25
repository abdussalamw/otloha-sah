import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Playback Manager States
abstract class PlaybackManagerState extends Equatable {
  const PlaybackManagerState();

  @override
  List<Object> get props => [];
}

class PlaybackManagerInitial extends PlaybackManagerState {}

class PlaybackManagerPlaying extends PlaybackManagerState {
  final String filePath;

  const PlaybackManagerPlaying(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class PlaybackManagerStopped extends PlaybackManagerState {}

// Playback Manager Cubit
class PlaybackManagerCubit extends Cubit<PlaybackManagerState> {
  PlaybackManagerCubit() : super(PlaybackManagerInitial());

  // void stopAllPlayback() {
  //   emit(PlaybackManagerStopped());
  // }

  void startPlayback(String filePath) {
    emit(PlaybackManagerPlaying(filePath));
  }
}
