part of 'lesson_cubit_cubit.dart';

class LessonCubitState extends Equatable {
  const LessonCubitState();

  @override
  List<Object> get props => [];
}

class LessonCubitInitial extends LessonCubitState {}

class LessonCubitLoading extends LessonCubitState {}

class LessonCubitSuccess extends LessonCubitState {
  final Lesson lesson;

  const LessonCubitSuccess(this.lesson);

  @override
  List<Object> get props => [lesson];
}

class LessonCubitError extends LessonCubitState {
  final String error;

  const LessonCubitError(this.error);

  @override
  List<Object> get props => [error];
}
