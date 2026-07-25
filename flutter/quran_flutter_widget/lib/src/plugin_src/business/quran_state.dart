part of 'quran_cubit.dart';

abstract class QuranState {}

class QuranInitialState extends QuranState {}

class PagesFetchLoadingState extends QuranState {}

class PagesFetchedState extends QuranState {
  final Map<int, List<Verse>> pages;
  PagesFetchedState({
    required this.pages,
  });
}

class FetchNextPageState extends QuranState {}

class FetchPreviousPageState extends QuranState {}

class CreateWordsWidgets extends QuranState {}

class WordWidgetsCreated extends QuranState {
  final List<List<WordWidget>> lines;

  WordWidgetsCreated(this.lines);
}

class ChapterChangedState extends QuranState {
  final Chapter chapter;

  ChapterChangedState(this.chapter);
}

class PagesFetchErrorState extends QuranState {
  final String error;
  PagesFetchErrorState({
    required this.error,
  });
}

class PartChangedState extends QuranState {}

class OnPressState extends QuranState {}

class ChangePageState extends QuranState {}

class OnLongPressState extends QuranState {}

class HandelSelectedListState extends QuranState {}

class ChangeCurrentVerse extends QuranState {}
