import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_recieved.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_card/invitation_card_state.dart';

class InvitationCardCubit extends Cubit<InvitationCardState> {
  InvitationCardCubit({required this.invitationRecieved})
      : super(InvitationCardInitialState());

  final InvitationRecieved invitationRecieved;
  final InvitationsService _invitationsService = InvitationsService();

  acceptInvitation() async {
    emit(InvitationCardLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      Response res = await _invitationsService.respondById(
        invitationId: invitationRecieved.id,
        status: 'accepted',
      );
      emit(InvitationCardAcceptedState());
      return res;
    }, '', false);
    if (state is InvitationCardLoadingState) {
      emit(InvitationCardInitialState());
    }
  }

  rejectInvitation() async {
    emit(InvitationCardLoadingState());
    await ExceptionHandling.hanleToastException(() async {
      var res = await _invitationsService.respondById(
        invitationId: invitationRecieved.id,
        status: 'rejected',
      );
      emit(InvitationCardRejectedState());
      return res;
    }, '', false);
    if (state is InvitationCardLoadingState) {
      emit(InvitationCardInitialState());
    }
  }
}
