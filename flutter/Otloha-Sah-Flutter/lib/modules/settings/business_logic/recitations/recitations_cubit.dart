import 'package:bloc/bloc.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'recitations_state.dart';

class RecitationsCubit extends Cubit<RecitationsState> {
  RecitationsCubit() : super(RecitationsInitial());

  int narration = QuranCacheRepository.narrationSelectedId ?? 1;
  List<Recitation>? recitations;
  fetchRecitations({String? qurey}) async {
    narration = QuranCacheRepository.narrationSelectedId ?? 1;
    try {
      recitations = await DataSource.instance
              .fetchRecitationsList(narrationId: narration) ??
          [];
      if (recitations != null && recitations!.isEmpty) {
        emit(RecitationsErrorState(EmptyListException()));
        return;
      }
      emit(RecitationsFetched(
          recitations!, QuranCacheRepository.selectedRecitationId ?? 1));
    } on Exception catch (e) {
      emit(RecitationsErrorState(e));
    }
  }

  setRecitation(int recitation, {String? name}) {
    QuranCacheRepository.setSelectedRecitationId(recitation);
    QuranCacheRepository.setSelectedRecitationName(name!);

    SettingsMenusData().downloadRecitations[0].subTitle = name;

    emit(RecitationsFetched(
        recitations!, QuranCacheRepository.selectedRecitationId ?? 1));
  }
}
