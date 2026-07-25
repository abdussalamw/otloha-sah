import 'package:equatable/equatable.dart';

abstract class RecordState extends Equatable {}

class RecordInitial extends RecordState {
  @override
  List<Object?> get props => [];
}

class RecordingState extends RecordState {
  final int duration;
  RecordingState({required this.duration});

  @override
  List<int?> get props => [duration];
}

class InitiateRecordingState extends RecordState {
  @override
  List<Object?> get props => [];
}

class PauseRecordState extends RecordState {
  @override
  List<Object?> get props => [];
}

class RecordError extends RecordState {
  @override
  List<Object?> get props => [];
}

class RecordEmpty extends RecordState {
  @override
  List<Object?> get props => [];
}

class PlayRecordedFileState extends RecordState {
  @override
  List<Object?> get props => [];
}

class PauseRecordedFileState extends RecordState {
  @override
  List<Object?> get props => [];
}
