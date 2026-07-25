import 'package:equatable/equatable.dart';

abstract class TeacherRegistrationState extends Equatable {}

class TeacherRegistrationInitState extends TeacherRegistrationState {
  @override
  List<Object?> get props => [];
}

class TeacherRegistrationChangeState extends TeacherRegistrationState {
  final dynamic data;

  TeacherRegistrationChangeState(this.data);

  @override
  List<Object?> get props => [data];
}
