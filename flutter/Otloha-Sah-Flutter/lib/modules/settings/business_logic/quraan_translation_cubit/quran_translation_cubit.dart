import '../../../../core/error/exceptions.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import 'quran_translation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class QuranTranslationCubit extends Cubit<QuranTranslationState> {
  QuranTranslationCubit() : super(QuranTranslationInitial());
  static QuranTranslationCubit get(context) => BlocProvider.of(context);

  List<Translation>? translations;
  int trgamaId = QuranCacheRepository.quranTranslationSelectedId ?? 1;

  fetchTranslationList() {
    trgamaId = QuranCacheRepository.quranTranslationSelectedId ?? 1;

    try {
      DataSource.instance.fetchTranslationList().then((value) async {
        if (value != null && value.isNotEmpty) {
          translations = value;
          emit(QuranTranslationFetched(value));
        } else {
          emit(QuranTranslationError(EmptyListException()));
        }
      });
    } catch (e) {
      emit(QuranTranslationError(e));
    }
  }

  setTranslation(int selected, {String? name}) {
    QuranCacheRepository.setQuranTranslationSelectedId(selected);
    QuranCacheRepository.setQuranTranslationSelectedName(name!);
    trgamaId = selected;

    SettingsMenusData().downloadQTL[0].subTitle = name;
    emit(QuranTranslationFetched(translations ?? []));
  }

  isSelectd(int id) {
    return id == trgamaId;
  }
}
