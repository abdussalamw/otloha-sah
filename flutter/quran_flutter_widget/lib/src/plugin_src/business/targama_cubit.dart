import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_widget_flutter/data_source/repository/translation_repository.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/quran_cubit.dart';

part 'targama_state.dart';

class TargamaCubit extends Cubit<TargamaState> {
  TargamaCubit() : super(TargamaInitial());

  final TranslationRepository _translationRepo = TranslationRepository();

  static TargamaCubit get(context) => BlocProvider.of<TargamaCubit>(context);

  List<TranslationVerse> verses = [];

  TranslationVerse? _selectedTargamaVerse;

  TranslationVerse? get selectedTargamaVerse => _selectedTargamaVerse;

  fetchVerseTargama() async {
    emit(TargamaVerseLoading());
    // try {
      _selectedTargamaVerse = await _translationRepo
          .fetchTranslationVerseByVerseId(QuranCubit.currentVerse!);
      print('tragama');
      print(QuranCubit.currentVerse);
      print(_selectedTargamaVerse);
      emit(TargamaVerseFetchedState(verses: verses));
    // } catch (e) {
    //   print(e);
    //   emit(TargamaVerseErrorState(exception: e));
    // }
  }

  // fetchVerseTargama(Verse verse) async {
  //   emit(TargamaVerseLoading());

  //   for (var v in verses) {
  //     if (v.verseNumber == verse.verseNumber) {
  //       _selectedTargamaVerse = v;
  //       break;
  //     } else {
  //       _selectedTargamaVerse = null;
  //     }
  //   }

  //   emit(TargamaVerseFetchedState(verses: verses));
  // }
}
