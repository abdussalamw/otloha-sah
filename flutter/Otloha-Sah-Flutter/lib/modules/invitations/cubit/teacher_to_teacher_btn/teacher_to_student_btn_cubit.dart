import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_teacher_btn/teacher_to_student_btn_state.dart';

class TeacherToTeacherCubit extends Cubit<TeacherToTeacherBtnState> {
  TeacherToTeacherCubit({required this.teacher})
      : super(TeacherToTeacherBtnInitialState()) {
    if (teacher.relationships.friend) {
      emit(TeacherToTeacherFriendsState());
    }

    if (teacher.invitations.outFriendRequest != null) {
      emit(TeacherToTeacherPendingInvitationState());
    }

    if (teacher.invitations.inFriendRequest != null) {
      emit(TeacherToTeacherWithRequestedInvitation());
    }
  }
  Teacher teacher;

  final InvitationsService _invitationsService = InvitationsService();
  final UserServices _userServices = UserServices();

  sendFriendRequest({required int userId}) async {
    emit(TeacherToTeacherBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.friendRequest,
        requesteeId: userId,
        requesteeType: 'user',
      );
      teacher = teacher.copyWith(
          invitations:
              teacher.invitations.copyWith(outFriendRequest: invitation.id));
      emit(TeacherToTeacherPendingInvitationState());
    }, '', false);

    if (state is TeacherToTeacherBtnLoadingState) {
      emit(TeacherToTeacherBtnInitialState());
    }
  }

  acceptFriendRequest() async {
    emit(TeacherToTeacherBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: teacher.invitations.inFriendRequest!,
        status: 'accepted',
      );
      teacher = teacher.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
          inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
          outFriendRequest: teacher.invitations.outFriendRequest,
          inFriendRequest: null,
          outSupervisionRequest: teacher.invitations.outSupervisionRequest,
          inSupervisionRequest: teacher.invitations.inSupervisionRequest,
        ),
      );
      emit(TeacherToTeacherFriendsState());
      return res;
    }, '', false);
    if (state is TeacherToTeacherBtnLoadingState) {
      emit(TeacherToTeacherWithRequestedInvitation());
    }
  }

  rejectFriendRequest() async {
    emit(TeacherToTeacherBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: teacher.invitations.inFriendRequest!,
        status: 'rejected',
      );
      teacher = teacher.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
          inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
          outFriendRequest: teacher.invitations.outFriendRequest,
          inFriendRequest: null,
          outSupervisionRequest: teacher.invitations.outSupervisionRequest,
          inSupervisionRequest: teacher.invitations.inSupervisionRequest,
        ),
      );
      emit(TeacherToTeacherFriendsState());
      return res;
    }, '', false);
    if (state is TeacherToTeacherBtnLoadingState) {
      emit(TeacherToTeacherWithRequestedInvitation());
    }
  }

  cancelFriendRequest() async {
    emit(TeacherToTeacherBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: teacher.invitations.outFriendRequest!,
        status: 'deleted',
      );
      emit(TeacherToTeacherBtnInitialState());
      return res;
    }, '', true);

    if (state is TeacherToTeacherBtnLoadingState) {
      emit(TeacherToTeacherPendingInvitationState());
    }
  }

  unfriend() async {
    emit(TeacherToTeacherBtnLoadingState());
    await ExceptionHandling.hanleToastException(
      () async {
        await _userServices.unfriend(teacher.id);
      },
      tr('You are not friends any more'),
      true,
    );
    if (state is TeacherToTeacherBtnLoadingState) {
      emit(TeacherToTeacherBtnInitialState());
    }
  }

  blockTeacher({required userId}) async {
    emit(TeacherToTeacherBtnLoadingState());
    Block block = await _invitationsService.createBlock(
      userId: userId,
      blockedType: 'user',
    );
    emit(TeacherToTeacherBlockState(block: block));
  }

  unblockTeacher() async {
    Block block = (state as TeacherToTeacherBlockState).block;
    emit(TeacherToTeacherBtnLoadingState());
    await _invitationsService.deleteBlock(blockId: block.id);
    emit(TeacherToTeacherBtnInitialState());
  }
}
