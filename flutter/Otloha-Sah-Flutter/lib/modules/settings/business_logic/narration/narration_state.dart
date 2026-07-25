part of 'narration_cubit.dart';

abstract class NarrationState {
  const NarrationState();
}

class NarrationInitial extends NarrationState {}

class NarrationFetched extends NarrationState {
  final List<Narration> narrations;
  final int selected;
  const NarrationFetched(this.narrations, this.selected);
}

class NarrationChangeSelected extends NarrationState {
  final List<Narration> narrations;
  final int selected;
  const NarrationChangeSelected(this.narrations, this.selected);
}

class NarrationError extends NarrationState {
  final String error;
  const NarrationError(this.error);
}
