import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/invitations.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_student_btn/teacher_to_student_btn_state.dart';

class TeacherToStudentBtnCubit extends Cubit<TeacherToStudentBtnState> {
  Student student;
  TeacherToStudentBtnCubit({required this.student})
      : super(TeacherToStudentBtnInitialState()) {
    emitBtnState();
  }

  final InvitationsService _invitationsService = InvitationsService();
  final UserServices _userServices = UserServices();

  emitBtnState() {
    if (student.invitations.inFriendRequest != null ||
        student.invitations.inSupervisionRequest != null) {
      emit(
        TeacherToStudentBtnWithRequestedInvitation(
          isFavoriteTeacher: student.relationships.supervision,
          isFriend: student.relationships.friend,
          isFriendPending: student.invitations.inFriendRequest != null,
          isSupervisionPending:
              student.invitations.inSupervisionRequest != null,
        ),
      );
    } else if (student.invitations.outFriendRequest != null ||
        student.invitations.outSupervisionRequest != null) {
      emit(TeacherToStudentBtnPendingRequestState(
        isFavoriteTeacher: student.relationships.supervision,
        isFriend: student.relationships.friend,
        isFriendPending: student.invitations.outFriendRequest != null,
        isSupervisionPending: student.invitations.outSupervisionRequest != null,
      ));
    } else if (student.relationships.friend ||
        student.relationships.supervision) {
      emit(
        TeacherToStudentBtnHasRelation(relationships: student.relationships),
      );
    } else {
      emit(TeacherToStudentBtnInitialState());
    }
  }

  requestSupervisionRequest() async {
    emit(TeacherToStudentBtnLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.supervisionRequest,
        requesteeType: 'user',
        requesteeId: student.id,
      );

      student = student.copyWith(
        invitations:
            student.invitations.copyWith(outSupervisionRequest: invitation.id),
      );
    }, tr('Ask to be favorite teacher has been sent'), true);

    emitBtnState();
  }

  requestFriendRequest() async {
    emit(TeacherToStudentBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.friendRequest,
        requesteeType: 'user',
        requesteeId: student.id,
      );
      student = student.copyWith(
        invitations:
            student.invitations.copyWith(outFriendRequest: invitation.id),
      );
    }, tr('Friend request has been sent'), true);

    emitBtnState();
  }

  respondOnRequest({
    required int invitationId,
    required InvitationType invitationType,
    required status,
  }) async {
    emit(TeacherToStudentBtnLoadingState());

    await ExceptionHandling.hanleToastException(
      () async {
        Response res = await _invitationsService.respondById(
          status: status,
          invitationId: invitationId,
        );

        if (invitationType == InvitationType.friendRequest) {
          invitationId = student.invitations.inFriendRequest ?? 0;
          student = student.copyWith(
              invitations: Invitations(
                outJoinEntityRequest: student.invitations.outJoinEntityRequest,
                inJoinEntityRequest: student.invitations.inJoinEntityRequest,
                outFriendRequest: student.invitations.outFriendRequest,
                inFriendRequest: null,
                outSupervisionRequest:
                    student.invitations.outSupervisionRequest,
                inSupervisionRequest: student.invitations.inSupervisionRequest,
              ),
              relationships:
                  student.relationships.copyWith(friend: status == 'accepted'));
        } else if (invitationType == InvitationType.supervisionRequest) {
          invitationId = student.invitations.inSupervisionRequest ?? 0;
          student = student.copyWith(
              invitations: Invitations(
                outJoinEntityRequest: student.invitations.outJoinEntityRequest,
                inJoinEntityRequest: student.invitations.inJoinEntityRequest,
                outFriendRequest: student.invitations.outFriendRequest,
                inFriendRequest: student.invitations.inFriendRequest,
                outSupervisionRequest:
                    student.invitations.outSupervisionRequest,
                inSupervisionRequest: null,
              ),
              relationships: student.relationships
                  .copyWith(supervision: status == 'accepted'));
        }

        return res;
      },
      '',
      false,
    );

    emitBtnState();
  }

  cancelSupervisionRequest() async {
    emit(TeacherToStudentBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: student.invitations.outSupervisionRequest!,
        status: 'deleted',
      );
      student = student.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: student.invitations.outJoinEntityRequest,
          inJoinEntityRequest: student.invitations.inJoinEntityRequest,
          outFriendRequest: student.invitations.outFriendRequest,
          inFriendRequest: student.invitations.inFriendRequest,
          outSupervisionRequest: null,
          inSupervisionRequest: student.invitations.inSupervisionRequest,
        ),
      );
      return res;
    }, '', true);

    emitBtnState();
  }

  cancelFriendRequest() async {
    emit(TeacherToStudentBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: student.invitations.outFriendRequest!,
        status: 'deleted',
      );
      student = student.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: student.invitations.outJoinEntityRequest,
          inJoinEntityRequest: student.invitations.inJoinEntityRequest,
          outFriendRequest: null,
          inFriendRequest: student.invitations.inFriendRequest,
          outSupervisionRequest: student.invitations.outSupervisionRequest,
          inSupervisionRequest: student.invitations.inSupervisionRequest,
        ),
      );
      return res;
    }, '', true);

    emitBtnState();
  }

  unfriend() async {
    emit(TeacherToStudentBtnLoadingState());

    await ExceptionHandling.hanleToastException(
      () async {
        await _userServices.unfriend(student.id);
        student = student.copyWith(
          relationships: student.relationships.copyWith(friend: false),
        );
      },
      tr('You are not friends any more'),
      true,
    );

    emitBtnState();
  }

  block() async {
    emit(TeacherToStudentBtnLoadingState());
    Block block = await _invitationsService.createBlock(
      userId: student.id,
      blockedType: 'user',
    );
    emit(TeacherToStudentBtnBlockState(block: block));
  }

  unblock() async {
    Block block = (state as TeacherToStudentBtnBlockState).block;
    emit(TeacherToStudentBtnLoadingState());
    await _invitationsService.deleteBlock(blockId: block.id);
    emit(TeacherToStudentBtnInitialState());
  }
}
