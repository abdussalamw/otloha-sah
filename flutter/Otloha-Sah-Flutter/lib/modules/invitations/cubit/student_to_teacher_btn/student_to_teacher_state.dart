import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/relationships.dart';

abstract class StudentToTeacherBtnState extends Equatable {}

class StudentToTeacherBtnInitialState extends StudentToTeacherBtnState {
  @override
  List<Object?> get props => [];
}

class StudentToTeacherBtnLoadingState extends StudentToTeacherBtnState {
  @override
  List<Object?> get props => [];
}

class StudentToTeacherBtnPendingRequeststate extends StudentToTeacherBtnState {
  final bool isFriend;
  final bool isFavoriteTeacher;
  final bool isFriendPending;
  final bool isSupervisionPending;

  StudentToTeacherBtnPendingRequeststate({
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

class StudentToTeacherBtnWithRequestedInvitation
    extends StudentToTeacherBtnState {
  final bool isFriend;
  final bool isFavoriteTeacher;
  final bool isFriendPending;
  final bool isSupervisionPending;

  StudentToTeacherBtnWithRequestedInvitation({
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

class StudentToTeacherBtnHasRelation extends StudentToTeacherBtnState {
  final Relationships relationships;

  StudentToTeacherBtnHasRelation({required this.relationships});

  @override
  List<Object?> get props => [relationships];
}

class StudentToTeacherBlockState extends StudentToTeacherBtnState {
  final Block block;

  StudentToTeacherBlockState({required this.block});
  @override
  List<Object?> get props => [block];
}
