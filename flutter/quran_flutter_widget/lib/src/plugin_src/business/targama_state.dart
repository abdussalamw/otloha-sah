part of 'targama_cubit.dart';

@immutable
abstract class TargamaState {}

class TargamaInitial extends TargamaState {}

class TargamaVerseLoading extends TargamaState {}

class TargamaVerseFetchedState extends TargamaState {
  final List<TranslationVerse> verses;
  TargamaVerseFetchedState({
    required this.verses,
  });
}

class TargamaVerseErrorState extends TargamaState {
  final Exception exception;
  TargamaVerseErrorState({
    required this.exception,
  });
}
