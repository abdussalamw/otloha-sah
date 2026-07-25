import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/modules/splash/business_logic/cubit/splash_cubit.dart';
import '../../../../../data_source/data_source.dart';
import 'progress_state.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(ProgressInitial());

  static ProgressCubit get(context) => BlocProvider.of(context);

  Future<void> getProgress(int chapterId) async {
    emit(ProgressLoading());
    try {
      if (SplashCubit.isLogin) {
        final progress = await AppDataSource()
            .getProgress(QuranCacheRepository.narrationSelectedId, chapterId);
        emit(ProgressLoaded(progress: progress));
      }
    } catch (e) {
      emit(ProgressError(message: e.toString()));
    }
  }
}
