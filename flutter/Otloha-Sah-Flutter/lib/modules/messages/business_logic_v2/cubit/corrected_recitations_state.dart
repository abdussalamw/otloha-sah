part of 'corrected_recitations_cubit.dart';

abstract class CorrectedRecitationsState {
  const CorrectedRecitationsState();
}

class CorrectedRecitationsInitial extends CorrectedRecitationsState {}

class RecitationsLoadingState extends CorrectedRecitationsState {}

class RecitationsSuccessState extends CorrectedRecitationsState {}

class RemoveUserRecitationState extends CorrectedRecitationsState {}

class RecitationsErrorState extends CorrectedRecitationsState {
  final Exception error;

  const RecitationsErrorState(this.error);
}

class NoAuthState extends CorrectedRecitationsState {}
