import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/repository/tajweed_repository.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/model/word.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/tajweed_state.dart';

class TajweedCubit extends Cubit<TajweedState> {
  TajweedCubit() : super(TajweedInitialState());
  final TajweedRepository _tajweedRepository = TajweedRepository();

  static TajweedCubit get(context) => BlocProvider.of<TajweedCubit>(context);

  int selected = -1;
  String? selectedText;

  List<TajweedCharacters> charachters = [];
  Map<int, bool> isWordHasTajweed = {};

  fetchVerseTajweedLetters(
    Verse? verse, {
    Word? selectedTajweedWord,
  }) async {
    emit(TajweedVerseLoading());
    selected = -1;
    selectedText = null;
    //  charachters = [];
    // try {
    charachters = await _tajweedRepository.fetchTajweedCharactersByVerseList(
            verseId: verse?.id ?? 1) ??
        [];
    print(charachters);
    await getWords(verse!);
    if (selectedTajweedWord != null) {
      if ((isWordHasTajweed[selectedTajweedWord.number] ?? false) &&
          selectedTajweedWord.verseNumber == verse.verseNumber) {
        var index = selectedTajweedWord.id;

        print('try get word index: $index');

        fetchVerseTajweedWord(
            selectedTajweedWord.number, selectedTajweedWord.text, index);
        return;
      } else {
        print('No tajweed to word ${selectedTajweedWord.text}');
      }
    } else {
      print('No tajweed to word ');
    }

    emit(TajweedVerseFetchedState(charachters));
    // } catch (e) {
    //   emit(TajweedErrorState(e as Exception));
    // }
  }

  fetchVerseTajweedWord(int wordNum, String wordText, int index) async {
    selected = index;
    selectedText = wordText;
    print('selected: $selected');
    List<TajweedCharacters> charachtersWord = [];

    for (var element in charachters) {
      if (element.wordNumber == wordNum) {
        charachtersWord.add(element);
      }
    }
    emit(TajweedVerseFetchedState(charachtersWord));
  }

  Future<Map<int, bool>> getWords(Verse verse) async {
    for (var word in verse.words ?? []) {
      isWordHasTajweed[word.number] =
          charachters.any((char) => char.wordNumber == word.number);
    }
    return isWordHasTajweed;
  }
}
