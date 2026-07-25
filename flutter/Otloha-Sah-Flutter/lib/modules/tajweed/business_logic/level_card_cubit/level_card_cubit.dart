import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';

part 'level_card_state.dart';

class LevelCardCubit extends Cubit<LevelCardState> {
  LevelCardCubit() : super(LevelCardInitial());

  selectLevel(TajweedLevel tajweedLevel) {
    emit(LevelCardSelected(tajweedLevel));
  }
}
