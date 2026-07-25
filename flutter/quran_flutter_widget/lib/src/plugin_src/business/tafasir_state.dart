part of 'tafasir_cubit.dart';

@immutable
abstract class TafasirState {}

class TafasirInitial extends TafasirState {}

class TafasirVerseLoading extends TafasirState {}

class TafasirVerseFetchedState extends TafasirState {
  final List<ExplanationVerse> verses;
  TafasirVerseFetchedState({
    required this.verses,
  });
}

class TafasirVerseErrorState extends TafasirState {
  final Exception exception;
  TafasirVerseErrorState({
    required this.exception,
  });
}
