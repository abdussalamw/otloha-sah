part of 'teachersend_cubit.dart';

abstract class TeacherSendState {
  const TeacherSendState();
}

class TeacherSendInitial extends TeacherSendState {}

class TeacherFetchedState extends TeacherSendState {}

class TeacherLoadingState extends TeacherSendState {}

class NoAuthState extends TeacherSendState {}

class TeacherErrorState extends TeacherSendState {}

class TeacherSentState extends TeacherSendState {}
