part of 'userrecitation_cubit.dart';

abstract class UserRecitationState {}

class UserRecitationInitial extends UserRecitationState {}

class UserRecitationFetched extends UserRecitationState {}

class SentRecitationFetched extends UserRecitationState {}

class UserRecitationError extends UserRecitationState {
  final Exception error;

  UserRecitationError(this.error);
}

class UserRecitationLoading extends UserRecitationState {}

class AuthErrorState extends UserRecitationState {}

class RemoveUserRecitationState extends UserRecitationState {}

// UserRecitationState

class PlayerIsPlay extends UserRecitationState {}

class PlayerIsPause extends UserRecitationState {}

class DeleteRecordState extends UserRecitationState {}

class EndRecordingState extends UserRecitationState {}

class StartRecordingState extends UserRecitationState {
  final String time;
  StartRecordingState({
    required this.time,
  });
}

class MoveToTrashState extends UserRecitationState {}

class ChangeIndexState extends UserRecitationState {}
