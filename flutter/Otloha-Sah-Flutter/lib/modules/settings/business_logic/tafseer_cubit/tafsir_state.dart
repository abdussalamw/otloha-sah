part of 'tafsir_cubit.dart';

abstract class TafsirState {}

class TafsirInitial extends TafsirState {}

class TafsirFetched extends TafsirState {
  final List<Explanation> tafsir;
  TafsirFetched(this.tafsir);
}

class TafsirError extends TafsirState {
  final Object error;
  TafsirError(this.error);
}

class TafsirEmpty extends TafsirState {
  final bool isNarrtion;
  TafsirEmpty(this.isNarrtion);
}
