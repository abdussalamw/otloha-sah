import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_widget_flutter/data_source/repository/tafseer_repository.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'tafasir_state.dart';

class TafasirCubit extends Cubit<TafasirState> {
  TafasirCubit() : super(TafasirInitial());

  final TafseerRepository _tafsirRepository = TafseerRepository();

  static TafasirCubit get(context) => BlocProvider.of<TafasirCubit>(context);

  List<ExplanationVerse> verses = [];

  ExplanationVerse? _selectedTafasirVerse;

  ExplanationVerse? get selectedTafasirVerse => _selectedTafasirVerse;

  fetchVerseTafseer() async {
    emit(TafasirVerseLoading());
    try {
      _selectedTafasirVerse =
          await _tafsirRepository.fetchExplanationVerseByVerseId(
              QuranCacheRepository.tafsirSelectedId ?? 1,
              QuranCubit.currentVerse!);

      emit(TafasirVerseFetchedState(verses: verses));
    }on Exception catch (e) {
      emit(TafasirVerseErrorState(exception: e ));
    }
  }

  // fetchVerseTafaseer(Verse verse) {
  //   // emit(TafasirVerseLoading());

  //   List<ExplanationVerse> ev = verses
  //       .where((element) => element.verseNumber == verse.verseNumber)
  //       .toList();

  //   if (ev.isEmpty) {
  //     _selectedTafasirVerse = null;
  //   } else {
  //     _selectedTafasirVerse = ev.first;
  //   }

  //   // emit(TafasirVerseFetchedState(verses: verses));
  // }
}
