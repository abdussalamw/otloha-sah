import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

abstract class TeacherToStudentBtnState extends Equatable {}

class TeacherToStudentBtnInitialState extends TeacherToStudentBtnState {
  @override
  List<Object?> get props => [];
}

class TeacherToStudentBtnLoadingState extends TeacherToStudentBtnState {
  @override
  List<Object?> get props => [];
}

class TeacherToStudentBtnPendingRequestState extends TeacherToStudentBtnState {
  final bool isFriend;
  final bool isFavoriteTeacher;
  final bool isFriendPending;
  final bool isSupervisionPending;

  TeacherToStudentBtnPendingRequestState({
    required this.isFriend,
    required this.isFavoriteTeacher,
    required this.isFriendPending,
    required this.isSupervisionPending,
  });

  @override
  List<Object?> get props => [
        isFriend,
        isFavoriteTeacher,
        isFriendPending,
        isSupervisionPending,
      ];
}

class TeacherToStudentBtnWithRequestedInvitation
    extends TeacherToStudentBtnState {
  final bool isFriend;
  final bool isFavoriteTeacher;
  final bool isFriendPending;
  final bool isSupervisionPending;

  TeacherToStudentBtnWithRequestedInvitation({
    required this.isFriend,
    required this.isFavoriteTeacher,
    required this.isFriendPending,
    required this.isSupervisionPending,
  });

  @override
  List<Object?> get props => [
        isFriend,
        isFavoriteTeacher,
        isFriendPending,
        isSupervisionPending,
      ];
}

class TeacherToStudentBtnHasRelation extends TeacherToStudentBtnState {
  final Relationships relationships;

  TeacherToStudentBtnHasRelation({required this.relationships});

  @override
  List<Object?> get props => [relationships];
}

class TeacherToStudentBtnBlockState extends TeacherToStudentBtnState {
  final Block block;

  TeacherToStudentBtnBlockState({required this.block});

  @override
  List<Object?> get props => [block];
}
