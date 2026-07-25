import 'package:bloc/bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../data_source/models/setting_model/init_data.dart';

part 'narration_state.dart';

class NarrationCubit extends Cubit<NarrationState> {
  List<Narration>? narrations;
  int? selected;

  NarrationCubit() : super(NarrationInitial());

  changeSelected(int index) async {
    selected = index;

    SettingsMenusData().settings[1].subTitle = '';
    SettingsMenusData().settings[0].subTitle = narrations![index].name;
    emit(NarrationChangeSelected(narrations!, index));
  }

  fetchNarration({String? qurey}) {
    try {
      DataSource.instance.fetchNarrationsList(qurey: qurey).then((value) async {
        if (value!.isNotEmpty) {
          int val = QuranCacheRepository.narrationSelectedId;
          for (var element in value) {
            if (element.id == val) {
              val = value.indexOf(element);
              SettingsMenusData().settings[0].subTitle =
                  element.name.translate();
              break;
            }
          }
          narrations = value;
          selected = val;
          emit(NarrationFetched(value, val));
        } else {
          emit(const NarrationError('Not Found Data'));
        }
      });
    } catch (e) {
      emit(NarrationError(e.toString()));
    }
  }
}
