import 'package:quran_widget_flutter/model/word_tajweed.dart';

abstract class TajweedState {}

class TajweedInitialState extends TajweedState {}

class TajweedVerseLoading extends TajweedState {}

class TajweedVerseFetchedState extends TajweedState {
  final List<TajweedCharacters> tajweedCharacters;

  TajweedVerseFetchedState(this.tajweedCharacters);
}

class TajweedChangeWord extends TajweedState {}

class TajweedErrorState extends TajweedState {
  final Exception error;

  TajweedErrorState(this.error);
}
