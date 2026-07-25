part of 'recitations_cubit.dart';

abstract class RecitationsState {
  const RecitationsState();
}

class RecitationsInitial extends RecitationsState {}

class RecitationsFetched extends RecitationsState {
  final List<Recitation> recitations;
  final int selected;
  const RecitationsFetched(this.recitations, this.selected);
}

class RecitationsErrorState extends RecitationsState {
  final Exception error;
  const RecitationsErrorState(this.error);
}
