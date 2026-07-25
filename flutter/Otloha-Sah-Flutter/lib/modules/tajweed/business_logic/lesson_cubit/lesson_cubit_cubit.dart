import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/lesson.dart';
import 'package:otloha_sah_flutter/data_source/remote/tajweed_service.dart';

part 'lesson_cubit_state.dart';

class LessonCubit extends Cubit<LessonCubitState> {
  final TajweedService _tajweedService;

  LessonCubit(this._tajweedService) : super(LessonCubitInitial());

  Future<void> fetchLesson(int id) async {
    try {
      emit(LessonCubitLoading());
      final lesson = await _tajweedService.getLesson(id);
      if (lesson != null) {
        emit(LessonCubitSuccess(lesson));
      } else {
        emit(const LessonCubitError('Lesson not found'));
      }
    } catch (e) {
      emit(LessonCubitError(e.toString()));
    }
  }
}
