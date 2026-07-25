import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_student_btn/student_to_student_btn_state.dart';

class StudentToStudentCubit extends Cubit<StudentToStudentBtnState> {
  StudentToStudentCubit({required this.student})
      : super(StudentToStudentBtnInitialState()) {
    if (student.relationships.friend) {
      emit(StudentToStudentFriendsState());
    }
    if (student.invitations.outFriendRequest != null) {
      emit(StudentToStudentPendingInvitationState());
    }

    if (student.invitations.inFriendRequest != null) {
      emit(StudentToStudentWithRequestedInvitation());
    }
  }
  Student student;

  final InvitationsService _invitationsService = InvitationsService();
  final UserServices _userServices = UserServices();

  sendFriendRequest({required int userId}) async {
    emit(StudentToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.friendRequest,
        requesteeId: userId,
        requesteeType: 'user',
      );
      student = student.copyWith(
          invitations:
              student.invitations.copyWith(outFriendRequest: invitation.id));
      emit(StudentToStudentPendingInvitationState());
    }, '', true);

    if (state is StudentToStudentBtnLoadingState) {
      emit(StudentToStudentBtnInitialState());
    }
  }

  acceptFriendRequest() async {
    print('asdasdasdda');
    emit(StudentToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: student.invitations.inFriendRequest!,
        status: 'accepted',
      );
      student = student.copyWith(
          invitations: student.invitations.copyWith(inFriendRequest: null));
      emit(StudentToStudentFriendsState());
      return res;
    }, '', false);
    if (state is StudentToStudentBtnLoadingState) {
      emit(StudentToStudentWithRequestedInvitation());
    }
  }

  rejectFriendRequest() async {
    emit(StudentToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: student.invitations.inFriendRequest!,
        status: 'rejected',
      );
      student = student.copyWith(
          invitations: student.invitations.copyWith(inFriendRequest: null));
      emit(StudentToStudentFriendsState());
      return res;
    }, '', false);
    if (state is StudentToStudentBtnLoadingState) {
      emit(StudentToStudentWithRequestedInvitation());
    }
  }

  cancelFriendRequest() async {
    emit(StudentToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: student.invitations.outFriendRequest!,
        status: 'deleted',
      );
      emit(StudentToStudentBtnInitialState());
      return res;
    }, '', true);

    if (state is StudentToStudentBtnLoadingState) {
      emit(StudentToStudentPendingInvitationState());
    }
  }

  unfriend() async {
    emit(StudentToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(
      () async {
        await _userServices.unfriend(student.id);
      },
      tr('You are not friends any more'),
      true,
    );
    if (state is StudentToStudentBtnLoadingState) {
      emit(StudentToStudentBtnInitialState());
    }
  }

  blockStudent({required userId}) async {
    emit(StudentToStudentBtnLoadingState());
    Block block = await _invitationsService.createBlock(
      userId: userId,
      blockedType: 'user',
    );
    emit(StudentToStudentBlockState(block: block));
  }

  unblockStudent() async {
    Block block = (state as StudentToStudentBlockState).block;
    emit(StudentToStudentBtnLoadingState());
    await _invitationsService.deleteBlock(blockId: block.id);
    emit(StudentToStudentBtnInitialState());
  }
}
