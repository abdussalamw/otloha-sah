import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';

abstract class StudentToStudentBtnState extends Equatable {}

class StudentToStudentBtnInitialState extends StudentToStudentBtnState {
  @override
  List<Object?> get props => [];
}

class StudentToStudentBtnLoadingState extends StudentToStudentBtnState {
  @override
  List<Object?> get props => [];
}

class StudentToStudentPendingInvitationState extends StudentToStudentBtnState {
  StudentToStudentPendingInvitationState();

  @override
  List<Object?> get props => [];
}

class StudentToStudentFriendsState extends StudentToStudentBtnState {
  @override
  List<Object?> get props => [];
}

class StudentToStudentWithRequestedInvitation extends StudentToStudentBtnState {
  StudentToStudentWithRequestedInvitation();

  @override
  List<Object?> get props => [];
}

class StudentToStudentBlockState extends StudentToStudentBtnState {
  final Block block;

  StudentToStudentBlockState({required this.block});
  @override
  List<Object?> get props => [];
}
