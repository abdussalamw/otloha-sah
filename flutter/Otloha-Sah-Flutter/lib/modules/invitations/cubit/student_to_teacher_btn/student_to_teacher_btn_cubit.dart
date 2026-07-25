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
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_state.dart';

class StudentToTeacherBtnCubit extends Cubit<StudentToTeacherBtnState> {
  Teacher teacher;
  StudentToTeacherBtnCubit({required this.teacher})
      : super(StudentToTeacherBtnInitialState()) {
    emitBtnState();
  }

  final InvitationsService _invitationsService = InvitationsService();
  final UserServices _userServices = UserServices();

  emitBtnState() {
    if (teacher.invitations.inFriendRequest != null ||
        teacher.invitations.inSupervisionRequest != null) {
      emit(
        StudentToTeacherBtnWithRequestedInvitation(
          isFavoriteTeacher: teacher.relationships.supervision,
          isFriend: teacher.relationships.friend,
          isFriendPending: teacher.invitations.inFriendRequest != null,
          isSupervisionPending:
              teacher.invitations.inSupervisionRequest != null,
        ),
      );
    } else if (teacher.invitations.outFriendRequest != null ||
        teacher.invitations.outSupervisionRequest != null) {
      emit(StudentToTeacherBtnPendingRequeststate(
        isFavoriteTeacher: teacher.relationships.supervision,
        isFriend: teacher.relationships.friend,
        isFriendPending: teacher.invitations.outFriendRequest != null,
        isSupervisionPending: teacher.invitations.outSupervisionRequest != null,
      ));
    } else if (teacher.relationships.friend ||
        teacher.relationships.supervision) {
      emit(
        StudentToTeacherBtnHasRelation(relationships: teacher.relationships),
      );
    } else {
      emit(StudentToTeacherBtnInitialState());
    }
  }

  requestSupervisionRequest() async {
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.supervisionRequest,
        requesteeType: 'user',
        requesteeId: teacher.id,
      );

      teacher = teacher.copyWith(
        invitations:
            teacher.invitations.copyWith(outSupervisionRequest: invitation.id),
      );
    }, tr('Ask to be favorite teacher has been sent'), true);

    emitBtnState();
  }

  requestFriendRequest() async {
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Invitation invitation = await _invitationsService.createInvitation(
        invitationType: InvitationType.friendRequest,
        requesteeType: 'user',
        requesteeId: teacher.id,
      );
      teacher = teacher.copyWith(
        invitations:
            teacher.invitations.copyWith(outFriendRequest: invitation.id),
      );
    }, tr('Friend request has been sent'), true);

    emitBtnState();
  }

  respondOnRequest({
    required int invitationId,
    required InvitationType invitationType,
    required status,
  }) async {
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(
      () async {
        Response res = await _invitationsService.respondById(
          invitationId: invitationId,
          status: status,
        );
        if (invitationType == InvitationType.friendRequest) {
          teacher = teacher.copyWith(
              invitations: Invitations(
                outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
                inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
                outFriendRequest: teacher.invitations.outFriendRequest,
                inFriendRequest: null,
                outSupervisionRequest:
                    teacher.invitations.outSupervisionRequest,
                inSupervisionRequest: teacher.invitations.inSupervisionRequest,
              ),
              relationships:
                  teacher.relationships.copyWith(friend: status == 'accepted'));
        } else if (invitationType == InvitationType.supervisionRequest) {
          teacher = teacher.copyWith(
              invitations: Invitations(
                outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
                inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
                outFriendRequest: teacher.invitations.outFriendRequest,
                inFriendRequest: teacher.invitations.inFriendRequest,
                outSupervisionRequest:
                    teacher.invitations.outSupervisionRequest,
                inSupervisionRequest: null,
              ),
              relationships: teacher.relationships
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
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: teacher.invitations.outSupervisionRequest!,
        status: 'deleted',
      );
      teacher = teacher.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
          inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
          outFriendRequest: teacher.invitations.outFriendRequest,
          inFriendRequest: teacher.invitations.inFriendRequest,
          outSupervisionRequest: null,
          inSupervisionRequest: teacher.invitations.inSupervisionRequest,
        ),
      );
      return res;
    }, '', false);

    emitBtnState();
  }

  cancelFriendRequest() async {
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: teacher.invitations.outFriendRequest!,
        status: 'deleted',
      );
      teacher = teacher.copyWith(
        invitations: Invitations(
          outJoinEntityRequest: teacher.invitations.outJoinEntityRequest,
          inJoinEntityRequest: teacher.invitations.inJoinEntityRequest,
          outFriendRequest: null,
          inFriendRequest: teacher.invitations.inFriendRequest,
          outSupervisionRequest: teacher.invitations.outSupervisionRequest,
          inSupervisionRequest: teacher.invitations.inSupervisionRequest,
        ),
      );
      return res;
    }, '', true);

    emitBtnState();
  }

  unfriend() async {
    emit(StudentToTeacherBtnLoadingState());

    await ExceptionHandling.hanleToastException(
      () async {
        await _userServices.unfriend(teacher.id);
        teacher = teacher.copyWith(
          relationships: teacher.relationships.copyWith(friend: false),
        );
      },
      tr('You are not friends any more'),
      true,
    );

    emitBtnState();
  }

  removeAsFavoriteTeacher() {
    emit(StudentToTeacherBtnLoadingState());
    ExceptionHandling.hanleToastException(() {
      UserServices().removeFavoriteTeacher();

      teacher = teacher.copyWith(
        relationships: teacher.relationships.copyWith(supervision: false),
      );
    }, tr('Teacher removed'), true);
    emitBtnState();
  }

  block() async {
    emit(StudentToTeacherBtnLoadingState());
    Block block = await _invitationsService.createBlock(
      userId: teacher.id,
      blockedType: 'user',
    );
    emit(StudentToTeacherBlockState(block: block));
  }

  unblock() async {
    Block block = (state as StudentToTeacherBlockState).block;
    emit(StudentToTeacherBtnLoadingState());
    await _invitationsService.deleteBlock(blockId: block.id);
    emit(StudentToTeacherBtnInitialState());
  }
}
