import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_widget_flutter/model/translatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'tajweed_state.dart';

class TajweedCubit extends Cubit<TajweedState> {
  static TajweedCubit get(context) => BlocProvider.of(context);

  List<TajweedBook>? tajweedBooks;
  int tajweedId = QuranCacheRepository.selectedTajweedId ?? 1;

  TajweedCubit() : super(TajweedInitial());
  fetchTajweedList() {
    tajweedId = QuranCacheRepository.selectedTajweedId ?? -1;
    try {
      DataSource.instance
          .fetchTajweedBooksList(
              narrationId: QuranCacheRepository.narrationSelectedId)
          .then((value) async {
        if (value!.isNotEmpty) {
          tajweedBooks = value;
          emit(TajweedFetched(value, tajweedId));
        } else {
          emit(TajweedError(EmptyListException()));
        }
      });
    } catch (e) {
      emit(TajweedError(e));
    }
  }

  setTajweed(int selected, {dynamic name}) {
    QuranCacheRepository.setSelectedTajweedId(selected);
    QuranCacheRepository.setSelectedTajweedName(json.encode(name));

    tajweedId = selected;

    SettingsMenusData().downloadTajweed[0].subTitle = name?.translate();
    emit(TajweedFetched(tajweedBooks ?? [], tajweedId));
  }
}
