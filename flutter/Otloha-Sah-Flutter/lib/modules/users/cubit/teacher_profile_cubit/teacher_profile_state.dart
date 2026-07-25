import 'package:otloha_sah_flutter/data_source/models/user/details_models/teacher_profile.dart';

abstract class TeacherProfileState {}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileLoaded extends TeacherProfileState {
  final TeacherProfile teacher;

  TeacherProfileLoaded(this.teacher);
}

class TeacherProfileError extends TeacherProfileState {
  final String message;

  TeacherProfileError(this.message);
}
