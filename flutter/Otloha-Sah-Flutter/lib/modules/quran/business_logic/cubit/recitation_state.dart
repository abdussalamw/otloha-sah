part of 'recitation_cubit.dart';

abstract class RecitationAddState {
  const RecitationAddState();
}

class RecitationInitial extends RecitationAddState {}

class GetDurationState extends RecitationAddState {}

class ChangeDurationState extends RecitationAddState {}

class PlayerIsPause extends RecitationAddState {}

class PlayerIsPlay extends RecitationAddState {}
