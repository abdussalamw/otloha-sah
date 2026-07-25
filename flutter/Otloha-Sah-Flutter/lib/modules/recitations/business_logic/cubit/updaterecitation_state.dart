part of 'updaterecitation_cubit.dart';

abstract class UpdateRecitationState extends Equatable {
  const UpdateRecitationState();
}

class UpdateRecitationInitial extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class UpdatedRecitationRecorded extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class UpdateRecitationLoading extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class UserRecitationFetched extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class DeleteRecordState extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class PlayerIsPlay extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class PlayerIsPause extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class ChangeDurationState extends UpdateRecitationState {
  final Duration duration;

  const ChangeDurationState(this.duration);
  @override
  List<Object?> get props => [duration];
}

class UpdateListState extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}

class ChangePlayingNowState extends UpdateRecitationState {
  final bool isPlay;

  const ChangePlayingNowState(this.isPlay);
  @override
  List<Object?> get props => [isPlay];
}

class RecitationUpdated extends UpdateRecitationState {
  @override
  List<Object?> get props => [];
}
