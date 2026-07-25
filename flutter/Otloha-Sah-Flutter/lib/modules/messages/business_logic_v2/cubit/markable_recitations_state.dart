part of 'markable_recitations_cubit.dart';

abstract class MarkableRecitationsState {
  const MarkableRecitationsState();
}

class MarkableRecitationsInitial extends MarkableRecitationsState {}

class RecitationsLoadingState extends MarkableRecitationsState {}

class RecitationsSuccessState extends MarkableRecitationsState {}

class RemoveUserRecitationState extends MarkableRecitationsState {}

class RecitationsErrorState extends MarkableRecitationsState {
  final Exception error;

  const RecitationsErrorState(this.error);
}

class NoAuthState extends MarkableRecitationsState {}
