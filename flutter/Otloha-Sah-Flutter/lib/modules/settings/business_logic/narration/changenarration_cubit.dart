import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/data_source.dart';
import 'package:quran_widget_flutter/model/narration.dart';

part 'changenarration_state.dart';

class ChangenarrationCubit extends Cubit<ChangenarrationState> {
  ChangenarrationCubit() : super(ChangenarrationInitial());

  static ChangenarrationCubit get(context) => BlocProvider.of(context);

  double progress = 0;

  void getChange(Narration narration) async {
    emit(ChangenarrationInitial());
    emit(ChangenarrationLoading());
    await DataSource.instance.changeNarration(narration: narration);
    // await DataSource.instance.fetchVersesList(onDownloadProgress: (p0, p1) {
    //   progress = p0 / p1;
    // });
    // progress = 0;
    emit(ChangenarrationSuccess());
  }
}
