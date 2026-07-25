import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';

abstract class TeacherToTeacherBtnState extends Equatable {}

class TeacherToTeacherBtnInitialState extends TeacherToTeacherBtnState {
  @override
  List<Object?> get props => [];
}

class TeacherToTeacherBtnLoadingState extends TeacherToTeacherBtnState {
  @override
  List<Object?> get props => [];
}

class TeacherToTeacherPendingInvitationState extends TeacherToTeacherBtnState {
  TeacherToTeacherPendingInvitationState();

  @override
  List<Object?> get props => [];
}

class TeacherToTeacherFriendsState extends TeacherToTeacherBtnState {
  @override
  List<Object?> get props => [];
}

class TeacherToTeacherWithRequestedInvitation extends TeacherToTeacherBtnState {
  TeacherToTeacherWithRequestedInvitation();

  @override
  List<Object?> get props => [];
}

class TeacherToTeacherBlockState extends TeacherToTeacherBtnState {
  final Block block;

  TeacherToTeacherBlockState({required this.block});
  @override
  List<Object?> get props => [];
}
