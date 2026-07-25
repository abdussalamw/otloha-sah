import '../../../../core/error/exceptions.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/data_source.dart';
import 'package:quran_widget_flutter/model/explanation.dart';

part 'tafsir_state.dart';

class TafsirCubit extends Cubit<TafsirState> {
  TafsirCubit() : super(TafsirInitial());

  static TafsirCubit get(context) => BlocProvider.of(context);
  List<Explanation>? tafsir;
  int tafsirId = QuranCacheRepository.tafsirSelectedId ?? 1;
  fetchTafsirList({String? qurey}) {
    try {
      DataSource.instance
          .fetchTafseerList(
              qurey: qurey,
              narrationId: QuranCacheRepository.narrationSelectedId)
          .then((value) async {
        if (value != null && value.isNotEmpty) {
          tafsir = value;
          emit(TafsirFetched(value));
        } else {
          emit(TafsirError(EmptyListException()));
        }
      });
    } catch (e) {
      emit(TafsirError(e));
    }
  }

  setTafseer(int selected, {String? name}) {
    QuranCacheRepository.setTafsirSelectedId(selected);
    QuranCacheRepository.setTafsirSelectedName(name!);
    tafsirId = selected;

    SettingsMenusData().downloadTafsir[0].subTitle = name;
    emit(TafsirFetched(tafsir ?? []));
  }
}
