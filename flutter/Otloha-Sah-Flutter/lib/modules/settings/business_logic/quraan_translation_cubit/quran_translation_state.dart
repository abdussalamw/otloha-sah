import 'package:quran_widget_flutter/model/translation.dart';

abstract class QuranTranslationState {}

class QuranTranslationInitial extends QuranTranslationState {}

class QuranTranslationFetched extends QuranTranslationState {
  final List<Translation> translations;
  QuranTranslationFetched(this.translations);
}

class QuranTranslationError extends QuranTranslationState {
  final Object error;
  QuranTranslationError(this.error);
}

class QuranTranslationEmpty extends QuranTranslationState {
  final bool isNarrtion;
  QuranTranslationEmpty(this.isNarrtion);
}
